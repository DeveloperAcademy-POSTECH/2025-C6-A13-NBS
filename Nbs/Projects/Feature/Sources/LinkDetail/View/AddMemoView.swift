//
//  AddMemoView.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import DesignSystem

/// 추가 메모뷰
struct AddMemoView: View {
  @FocusState private var isFocused: Bool
  @Binding var text: String
  var onFocusChanged: (Bool) -> Void = { _ in }
  @State private var textHeight: CGFloat = 295
}

extension AddMemoView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      if text.isEmpty && !isFocused {
        Text("추가할 메모를 입력해주세요")
          .font(.B1_M_HL)
          .foregroundStyle(.caption2)
          .padding(.leading, 16)
          .padding(.top, 16)
      }
      
      TextEditor(text: $text)
        .focused($isFocused)
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .padding(.vertical, 9)
        .padding(.horizontal, 14)
        .scrollDisabled(true)
        .frame(height: textHeight)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .onTapGesture { isFocused = true }
      
      Text(text.isEmpty ? " " : text)
        .font(.B1_M_HL)
        .foregroundStyle(.clear)
        .padding(.vertical, 9)
        .padding(.horizontal, 14)
        .background(
          GeometryReader { geo in
            Color.clear
              .onChange(of: geo.size.height) { _, newValue in
                let clamped = max(295, min(newValue, 1000))
                if abs(clamped - textHeight) > 1 {
                  textHeight = clamped
                }
              }
          }
        )
        .hidden()
    }
    .background(.bgMemo)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .onTapGesture {
      // 외부 탭 시 포커스 해제
      if isFocused {
        isFocused = false
      }
    }
    .onChange(of: isFocused) { _, newValue in
      onFocusChanged(newValue)
    }
  }
}
