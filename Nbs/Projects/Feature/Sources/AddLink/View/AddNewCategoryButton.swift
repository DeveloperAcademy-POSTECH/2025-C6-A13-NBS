//
//  AddNewCategory.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import DesignSystem

struct AddNewCategoryButton: View {
  var body: some View {
    Button {
//      withAnimation()
    } label: {
      HStack(spacing: 0) {
        Image(icon: Icon.smallPlus)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(.bl6)
          .frame(width: 20, height: 20)
        Text("새 카테고리")
          .font(.B2_SB)
          .foregroundStyle(.bl6)
      }
      .padding(.vertical, 6.5)
      .padding(.trailing, 16)
      .padding(.leading, 10)
      .background(
        RoundedRectangle(cornerRadius: 24)
          .fill(.bl1)
      )
    }
    .buttonStyle(.plain)
  }
}
