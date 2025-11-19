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
  var onDone: () -> Void = {}
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
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("완료") {
              isFocused = false
              onDone()
            }
          }
        }
      //
      //      Text(text.isEmpty ? " " : text)
      //        .font(.B1_M_HL)
      //        .foregroundStyle(.clear)
      //        .padding(.vertical, 9)
      //        .padding(.horizontal, 14)
      //        .background(
      //          GeometryReader { geo in
      //            Color.clear
      //              .onChange(of: geo.size.height) { _, newValue in
      //                let clamped = max(295, min(newValue, 0))
      //                if abs(clamped - textHeight) > 1 {
      //                  textHeight = clamped
      //                }
      //              }
      //          }
      //        )
      //        .hidden()
      Text(text + " ")
        .font(.B1_M_HL)
        .padding(EdgeInsets(top: 9, leading: 14, bottom: 9, trailing: 14))
        .background(
          GeometryReader { geo in
            Color.clear.onAppear {
              updateHeight(geo.size.height)
            }
            .onChange(of: geo.size.height) { _, newValue in
              updateHeight(newValue)
            }
          }
        )
        .opacity(0)
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
  
  private func updateHeight(_ newValue: CGFloat) {
    DispatchQueue.main.async {
      let minHeight: CGFloat = 295
      let maxHeight: CGFloat = 1000
      let clamped = min(max(newValue, minHeight), maxHeight)
      
      if abs(clamped - textHeight) > 1 {
        textHeight = clamped
      }
    }
  }
}
