//
//  ScrollFloatingButton.swift
//  DesignSystem
//
//  Created by 이안 on 10/18/25.
//

import SwiftUI

/// 스크롤 위치에 따라 나타나는 플로팅 버튼 컴포넌트
///
/// 사용자가 스크롤을 일정 위치 이상 내렸을 때 나타나는 플로팅 버튼
/// 탭 시 지정된 ScrollView 위치(`targetID`)로 스크롤을 이동
///
/// - Parameters:
///   - isVisible: 버튼 표시 여부 (스크롤 상태와 연동)
///   - proxy: 스크롤 이동을 제어하는 `ScrollViewProxy`
///   - targetID: 스크롤 이동 대상 ID (기본값 `"top"`)
///   - bottomPadding: 화면 하단 여백 (기본값 `40`)
///   - trailingPadding: 화면 우측 여백 (기본값 `20`)
///   - onTap: 버튼 탭 시 추가로 실행할 클로저 (선택사항)
///
/// - Example:
/// ```swift
/// ScrollFloatingButton(
///   isVisible: $showButton,
///   proxy: proxy,
///   targetID: "top"
/// )
/// ```
public struct ScrollFloatingButton: View {
  
  // MARK: - Properties
  @Binding var isVisible: Bool
  let proxy: ScrollViewProxy
  let targetID: String
  var bottomPadding: CGFloat
  var trailingPadding: CGFloat
  var onTap: (() -> Void)? = nil
  
  
  // MARK: - Init
  public init(
    isVisible: Binding<Bool>,
    proxy: ScrollViewProxy,
    targetID: String = "top",
    bottomPadding: CGFloat = 40,
    trailingPadding: CGFloat = 20,
    onTap: (() -> Void)? = nil
  ) {
    self._isVisible = isVisible
    self.proxy = proxy
    self.targetID = targetID
    self.bottomPadding = bottomPadding
    self.trailingPadding = trailingPadding
    self.onTap = onTap
  }
}

// MARK: - Body
extension ScrollFloatingButton {
  public var body: some View {
    Button {
      onTap?()
      withAnimation(.easeInOut) {
        proxy.scrollTo(targetID, anchor: .top)
      }
    } label: {
      Image(icon: Icon.arrowUp)
        .renderingMode(.template)
        .resizable()
        .scaledToFit()
        .foregroundStyle(.iconGray)
        .frame(width: 24, height: 24)
        .padding(12)
        .background(.n0)
        .clipShape(Circle())
        .shadow(color: Color(red: 0.43, green: 0.39, blue: 0.74).opacity(0.05), radius: 3, x: 0, y: 2)
        .shadow(color: Color(red: 0.24, green: 0.24, blue: 0.29).opacity(0.03), radius: 2, x: 0, y: 2)
        .overlay(
          RoundedRectangle(cornerRadius: 24)
            .inset(by: 0.5)
            .stroke(.divider1, lineWidth: 1)
        )
        .contentShape(Circle())
    }
    .padding(.trailing, trailingPadding)
    .padding(.bottom, bottomPadding)
    .opacity(isVisible ? 1 : 0)
    .scaleEffect(isVisible ? 1 : 0.8)
    .allowsHitTesting(isVisible)
    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isVisible)
  }
}

// MARK: - Preview
#Preview("ScrollFloatingButton") {
  ScrollViewReader { proxy in
    ZStack(alignment: .bottomTrailing) {
      Color.gray.opacity(0.1)
        .ignoresSafeArea()
      
      ScrollFloatingButton(
        isVisible: .constant(true),
        proxy: proxy,
        targetID: "top"
      )
    }
  }
}
