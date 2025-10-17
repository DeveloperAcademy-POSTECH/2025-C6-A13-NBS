//
//  CategoryButton.swift
//  ActionExtension
//
//  Created by 여성일 on 10/16/25.
//

import SwiftUI

import DesignSystem

// MARK: - Properties
struct CategoryButton: View {
  let image: String
  let categoryTitle: String
  let action: () -> Void
  
  init(
    image: String,
    categoryTitle: String,
    action: @escaping () -> Void
  ) {
    self.image = image
    self.categoryTitle = categoryTitle
    self.action = action
  }
}

// MARK: - View
extension CategoryButton {
  var body: some View {
    VStack {
      Button {
        action()
      } label: {
        ZStack {
          Image(systemName: image)
            .frame(width: 45, height: 45)
        }
        .frame(width: 96, height: 96)
        .background(.n30)
        .clipShape(RoundedRectangle(cornerRadius: 13.71))
      }
      .buttonStyle(.plain)
      
      Text("세계")
        .font(.B2_M)
        .foregroundStyle(.text1)
    }
  }
}

#Preview {
  CategoryButton(
    image: "plus",
    categoryTitle: "세계",
    action: { print("Category Tapped!") }
  )
}
