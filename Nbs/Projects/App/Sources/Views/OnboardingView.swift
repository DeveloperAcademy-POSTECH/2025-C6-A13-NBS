import SwiftUI

import DesignSystem

struct OnboardingView: View {
  @Binding var isNotOnboarding: Bool
  @State var currentPage = 0
  
  let textArray = [
    "기사를 읽으며\n실시간으로 기록을 남겨요",
    "내가 남긴 기록만 한눈에 확인해요",
    "읽은 기사에 나의 생각을 더해요"
  ]
  
  let desArray = [
    "주요 문장에 하이라이트하고, 메모를 남길 수 있어요",
    "내가 남긴 하이라이트와 메모만 빠르게 불러와 복잡한\n기사 속 생각을 정리할 수 있어요",
    "기사에 대한 추가적인 메모를 빠르게 남길 수 있어요"
  ]
  
  var body: some View {
    NavigationStack {
      VStack {
        TabView(selection: $currentPage) {
          ForEach(0..<3) { index in
            VStack {
              Text(textArray[index])
                .font(.H2)
                .padding(.horizontal, 20)
                .foregroundStyle(.text1)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text(desArray[index])
                .font(.C1)
                .foregroundColor(.caption2)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
              Spacer()
              Image(.onboarding)
                .resizable()
                .frame(width: 318, height: 315)
                .padding(.leading, 45)
                .padding(.bottom, 75)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .tag(index)
            .padding(.top, 72)
          }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
        CircularProgressView(currentPage: currentPage, numberOfPages: 3)
          .padding(.top, 32)
        
        Button(action: {
          if currentPage != 2 {
            currentPage += 1
          } else {
            isNotOnboarding = true
          }
        }) {
          Text(currentPage != 2 ? "다음" : "시작하기")
            .frame(maxWidth: .infinity)
            .padding()
            .font(.B1_SB)
            .background(DesignSystemAsset.bgBtn.swiftUIColor)
            .foregroundColor(.textw)
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
        
        if currentPage != 2 {
          Button(action: {
            isNotOnboarding = true
          }) {
            Text("건너뛰기")
              .font(.C2)
              .foregroundStyle(.caption2)
              .underline()
          }
          .padding(.top, 8)
        } else {
          if currentPage != 2 {
            Button(action: {
              isNotOnboarding = true
            }) {
              Text("건너뛰기")
                .font(.C2)
                .foregroundStyle(.caption2)
                .underline()
            }
            .padding(.top, 8)
          } else {
            Button(action: {
              isNotOnboarding = true
            }) {
              Text("건너뛰기")
                .font(.C2)
                .foregroundStyle(DesignSystemAsset.background.swiftUIColor)
                .underline()
            }
            .padding(.top, 8)
            .disabled(true)
          }
        }
      }
      .background(DesignSystemAsset.background.swiftUIColor)
      .navigationDestination(isPresented: $isNotOnboarding) {
        SafariPIP()
      }
    }
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(isNotOnboarding: .constant(true))
  }
}
