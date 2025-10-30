//
//  SelectBottomSheetItem.swift
//  DesignSystem
//
//  Created by 이안 on 10/15/25.
//

import SwiftUI

// MARK: - Properties
struct SelectBottomSheetItem: View {
  let title: String
  let isSelected: Bool 
  
  let action: () -> Void
  
  init(
    title: String,
    isSelected: Bool,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.isSelected = isSelected
    self.action = action
  }
  
  private var foregroundColor: Color {
    isSelected ? .bl6 : .text1
  }
}

// MARK: - View
extension SelectBottomSheetItem {
  var body: some View {
    Button {
      action()
    } label: {
      HStack {
        Text(title)
          .font(isSelected ? .B1_SB : .B1_M)
          .foregroundStyle(foregroundColor)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 6)
          .padding(.trailing, 12)
          .padding(.vertical, 4)
          
        if isSelected {
          Image(icon: Icon.check)
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .padding(4)
            .foregroundStyle(foregroundColor)
        }
      }
      .contentShape(.rect)
      .padding(.vertical, 4)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  SelectBottomSheetItem(title: "전체", isSelected: true, action: {})
}
