//
//  AddFloatingView.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import DesignSystem

struct AddFloatingButton {
  
}

extension AddFloatingButton: View {
  var body: some View {
    if #available(iOS 26, *) {
      
    } else {
      
    }
    Button {
      
    } label: {
      Image(icon: Icon.plus)
        .foregroundStyle(DesignSystemAsset.bl6.swiftUIColor)
        .frame(width: 48, height: 48)
        .background(.n0)
        .clipShape(Circle())
    }
  }
}
