import SwiftUI

public struct ContentView: View {
  @State private var isOnboarding = false
  
  public init() {}
  
  public var body: some View {
//    OnboardingView(isNotOnboarding: $isOnboarding)
    SafariPIP()
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
