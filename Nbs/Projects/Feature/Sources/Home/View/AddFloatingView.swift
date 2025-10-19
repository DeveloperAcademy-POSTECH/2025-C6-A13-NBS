//
//  AddFloatingView.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import DesignSystem

struct AddFloatingButton: View {
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
      Image(icon: Icon.plus)
        .renderingMode(.template)
        .foregroundStyle(DesignSystemAsset.bl6.swiftUIColor)
        .frame(width: 48, height: 48)
        .background(.n0)
        .clipShape(Circle())
    }
  }
}
