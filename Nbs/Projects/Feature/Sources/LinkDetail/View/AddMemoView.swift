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
  @State private var memoText: String = ""
  @FocusState private var isFocused: Bool
}

extension AddMemoView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      if memoText.isEmpty && !isFocused {
        Text("추가할 메모를 입력해주세요")
          .font(.B1_M_HL)
          .foregroundStyle(.caption2)
          .padding(.leading, 16)
          .padding(.top, 16)
      }
      
      TextEditor(text: $memoText)
        .focused($isFocused)
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .frame(minHeight: 295, alignment: .topLeading)
        .onTapGesture {
          isFocused = true
        }
    }
    .background(.bgMemo)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .onTapGesture {
      // 외부 탭 시 포커스 해제
      if isFocused {
        isFocused = false
      }
    }
  }
}

#Preview {
  AddMemoView()
}
