//
//  SheetHeader.swift
//  DesignSystem
//
//  Created by 이안 on 10/21/25.
//

import SwiftUI

public struct SheetHeader: View {
  let title: String
  let onDismiss: () -> Void
  
  public init(title: String, onDismiss: @escaping () -> Void) {
    self.title = title
    self.onDismiss = onDismiss
  }
}

extension SheetHeader {
  public var body: some View {
    HStack {
      Color.clear.frame(width: 44, height: 44)
      
      Text(title)
        .font(.B1_SB)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity)
      
      Button(action: onDismiss) {
        Image(icon: Icon.x)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(.icon)
          .padding(12)
      }
    }
    .frame(height: 48)
    .padding(.top, 8)
  }
}
