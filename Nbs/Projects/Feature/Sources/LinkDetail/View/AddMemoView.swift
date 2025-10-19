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
  // MARK: - State
  @State private var memoText: String = ""
  @State private var isEditing: Bool = false
  @FocusState private var isFocused: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      if isEditing {
        editingView
      } else {
        displayView
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 16)
    .animation(.easeInOut(duration: 0.25), value: isEditing)
    .background(Color.background)
    .onTapGesture {
      if memoText.isEmpty {
        withAnimation {
          isEditing = true
          isFocused = true
        }
      }
    }
  }
}

// MARK: - Subviews
extension AddMemoView {
  
  /// ✏️ 작성 중 (TextEditor)
  private var editingView: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("메모 작성 중")
          .font(.B2_M)
          .foregroundStyle(.caption2)
        Spacer()
        Button("완료") {
          withAnimation {
            isEditing = false
            isFocused = false
          }
        }
        .font(.B2_M)
        .foregroundStyle(.bl6)
      }
      
      TextEditor(text: $memoText)
        .focused($isFocused)
        .font(.B1_M)
        .foregroundStyle(.text1)
        .scrollContentBackground(.hidden)
        .padding(12)
        .frame(minHeight: 160, alignment: .topLeading)
        .background(Color.n0)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.divider1, lineWidth: 1)
        )
    }
  }
  
  /// 📄 읽기 모드
  private var displayView: some View {
    VStack(alignment: .leading, spacing: 8) {
      if memoText.isEmpty {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.n10)
          .overlay(
            Text("추가할 메모를 입력해주세요")
              .font(.B1_M_HL)
              .foregroundStyle(.caption2)
          )
          .frame(height: 160)
      } else {
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Text("추가 메모")
              .font(.B2_M)
              .foregroundStyle(.caption2)
            Spacer()
            Button {
              withAnimation {
                isEditing = true
                isFocused = true
              }
            } label: {
              Image(systemName: "square.and.pencil")
                .foregroundColor(.bl6)
            }
          }
          
          ScrollView {
            Text(memoText)
              .font(.B1_M)
              .foregroundStyle(.text1)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(12)
              .background(Color.n0)
              .clipShape(RoundedRectangle(cornerRadius: 12))
          }
        }
      }
    }
  }
}

// MARK: - Preview
#Preview("LinkMemoView") {
  VStack(spacing: 24) {
    AddMemoView()
  }
  .padding()
}
