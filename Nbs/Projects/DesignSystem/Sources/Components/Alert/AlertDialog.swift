//
//  AlertDialog.swift
//  DesignSystem
//
//  Created by 이안 on 10/16/25.
//

import SwiftUI

/// 공통 알럿 다이얼로그 컴포넌트
///
/// 디자인 시스템에 맞춘 커스텀 알럿으로, 항상 두 개의 버튼(취소 + 주요 액션)으로 구성
/// 주요 액션: `.confirm`, `.delete`, `.move` 타입 중 하나를 선택 가능
///
/// - Parameters:
///   - title: 알럿의 제목 텍스트
///   - subtitle: 선택적으로 표시할 부제목 텍스트
///   - cancelTitle: 왼쪽 취소 버튼의 텍스트 (기본값 "취소")
///   - onCancel: 취소 버튼이 눌렸을 때 실행할 추가 액션
///   - buttonType: 오른쪽 주요 액션 버튼의 타입 (`.confirm`, `.delete`, `.move`)
public struct AlertDialog: View {
  
  // MARK: - ButtonType
  /// 오른쪽 주요 액션 버튼 타입
  public enum ButtonType {
    case confirm(
      title: String = "확인",
      action: (() -> Void)? = nil
    )
    
    case delete(
      title: String = "삭제",
      action: (() -> Void)? = nil
    )
    
    case move(
      title: String = "나가기",
      action: (() -> Void)? = nil
    )
  }
  
  // MARK: - Properties
  let title: String
  let subtitle: String?
  let cancelTitle: String
  let onCancel: (() -> Void)?
  let buttonType: ButtonType
  
  // MARK: - Init
  public init(
    title: String,
    subtitle: String? = nil,
    cancelTitle: String = "취소",
    onCancel: (() -> Void)? = nil,
    buttonType: ButtonType
  ) {
    self.title = title
    self.subtitle = subtitle
    self.cancelTitle = cancelTitle
    self.onCancel = onCancel
    self.buttonType = buttonType
  }
}

// MARK: - Body
public extension AlertDialog {
  var body: some View {
    VStack(spacing: 0) {
      // 타이틀 모음
      titleContents
      
      // 구분선
      Rectangle()
        .frame(maxHeight: 1)
        .foregroundStyle(.divider1)
        .padding(.horizontal, 20)
      
      bottomContents
    }
    .background(.n0)
    .frame(maxWidth: 286)
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
  
  /// 타이틀 모음
  private var titleContents: some View {
    VStack(spacing: 8) {
      Text(title)
        .font(.B1_SB)
        .foregroundStyle(.text1)
      
      if let subtitle {
        Text(subtitle)
          .font(.C2)
          .foregroundStyle(.caption1)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(EdgeInsets(top: 28, leading: 16, bottom: 24, trailing: 16))
  }
  
  /// 버튼 모음
  private var bottomContents: some View {
    HStack(spacing: 0) {
      // 취소
      Button(cancelTitle) { onCancel?() }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .font(.B1_SB)
        .foregroundStyle(.caption1)
        .contentShape(Rectangle())
      
      // 구분선
      Rectangle()
        .frame(width: 1, height: 48)
        .foregroundStyle(.divider1)
      
      // 액션
      buttonContents
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .contentShape(Rectangle())
    }
    .padding(EdgeInsets(top: 8, leading: 16, bottom: 12, trailing: 16))
  }
  
  /// 버튼 모음
  private var buttonContents: some View {
    switch buttonType {
    case let .confirm(title, action):
      return AnyView(
        Button(title) { action?() }
          .font(.B1_SB)
          .foregroundStyle(.bl6)
      )
    case let .delete(title, action):
      return AnyView(
        Button(title) { action?() }
          .font(.B1_SB)
          .foregroundStyle(.danger)
      )
    case let .move(title, action):
      return AnyView(
        Button(title) { action?() }
          .font(.B1_SB)
          .foregroundStyle(.bl6)
      )
    }
  }
}

// MARK: - Preview
#Preview {
  ZStack {
    Color.gray
      .ignoresSafeArea()
    
    VStack(spacing: 10) {
      AlertDialog(
        title: "Title",
        subtitle: "subtitle",
        onCancel: { print("취소") },
        buttonType: .confirm { print("") }
      )
      
      AlertDialog(
        title: "Title",
        subtitle: "subtitle",
        onCancel: { print("취소") },
        buttonType: .delete { print("") }
      )
      
      AlertDialog(
        title: "Title",
        subtitle: "subtitle",
        onCancel: { print("취소") },
        buttonType: .move { print("") }
      )
      
      AlertDialog(
        title: "Title",
        onCancel: { print("취소") },
        buttonType: .delete { print("") }
      )
    }
  }
}
