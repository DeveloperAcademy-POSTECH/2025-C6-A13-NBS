import SwiftUI
import SwiftData

import Domain
import DesignSystem
import Feature
import LinkNavigator

@main
struct NbsApp: App {
  @State private var launchState: LaunchState = .splash
  @State private var showUpdateAlert = false
  
  let singleNavigator = SingleLinkNavigator(
    routeBuilderItemList: AppRouterGroup().routers(),
    dependency: AppDependency()
  )
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        switch launchState {
        case .splash:
          SplashView()
            .transition(.opacity)
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.55) {
                checkAppVersion()
              }
            }
            .alert(isPresented: $showUpdateAlert) {
              Alert(
                title: Text("업데이트 필요"),
                message: Text("새로운 버전이 있습니다.\n업데이트 후 다시 이용해주세요."),
                dismissButton: .default(Text("업데이트하기")) {
                  AppVersionCheck.appUpdate()
                }
              )
            }
          
        case .onboarding:
          LinkNavigationView(
            linkNavigator: singleNavigator,
            item: .init(path: Route.onboardingService.rawValue)
          )
          .ignoresSafeArea()
          .transition(.opacity)
          
        case .home:
          LinkNavigationView(
            linkNavigator: singleNavigator,
            item: .init(path: Route.home.rawValue)
          )
          .ignoresSafeArea()
          .transition(.opacity)
        }      }
      .animation(.easeInOut(duration: 0.3), value: launchState)
    }
  }
}

extension NbsApp {
  func checkAppVersion() {
    do {
      let _ = try AppVersionCheck.isUpdateAvailable { needUpdate, error in
        DispatchQueue.main.async {
          if let needUpdate = needUpdate, needUpdate == true {
            showUpdateAlert = true
          } else {
            moveToNextState()
          }
        }
      }
    } catch {
      let hasSeen = UserDefaults.standard.bool(forKey: UserDefaultsKey.onboarding)
      launchState = hasSeen ? .home : .onboarding
    }
  }
  
  func moveToNextState() {
    let hasSeen = UserDefaults.standard.bool(forKey: UserDefaultsKey.onboarding)
    launchState = hasSeen ? .home : .onboarding
  }
}
