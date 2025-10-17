//
//  ActionBottomSheet.swift
//  ActionExtension
//
//  Created by 여성일 on 10/16/25.
//

import SwiftUI

import DesignSystem

// MARK: - Properties
struct ActionBottomSheet: View {
  let saveAction: () -> Void
}

// MARK: - Views
extension ActionBottomSheet {
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      Color.white.ignoresSafeArea()
      VStack(spacing: 8) {
        HeaderView
          .padding(.vertical, 8)
          .padding(.horizontal, 20)
        SelectCategoryView
          .padding(.leading, 20)
      }
      .padding(.top, 8)
    }
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
  
  private var HeaderView: some View {
    HStack {
      HStack(spacing: 2) {
        Text("저장 완료")
          .font(.B1_SB)
          .foregroundStyle(.bl6)
      }
      
      Spacer()
      
      HStack(spacing: 8) {
        Button {
          print("Add Category Tapped")
        } label: {
          Text("+ 카테고리 추가")
            .font(.B2_SB)
            .foregroundStyle(.bl6)
            .frame(width: 119, height: 36)
            .background(.bl1)
            .clipShape(.capsule)
        }
        .buttonStyle(.plain)
        
        Button {
          print("Confirm Tapped")
        } label: {
          Text("확인")
            .font(.B2_SB)
            .foregroundStyle(.textw)
            .frame(width: 56, height: 36)
            .background(.bl6)
            .clipShape(.capsule)
        }
        .buttonStyle(.plain)
      }
    }
  }
  
  private var SelectCategoryView: some View {
    VStack(alignment: .leading) {
      Text("카테고리 선택하기")
        .font(.B2_SB)
        .foregroundStyle(.text1)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
          ForEach(0..<5) { _ in
            CategoryButton(image: "plus", categoryTitle: "세계", action: {})
          }
        }
      }
    }
  }
}

// MARK: - Components
private extension ActionBottomSheet {
  
}

#Preview {
  ActionBottomSheet(saveAction: {})
}
