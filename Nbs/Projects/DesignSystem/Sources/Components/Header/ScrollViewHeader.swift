//
//  ScrollViewHeader.swift
//  DesignSystem
//
//  Created by 홍 on 10/28/25.
//

import SwiftUI

public struct ScrollViewHeader {
  let headerTitle: HeaderNamespace.HeaderTitle
  let buttonTitle: HeaderNamespace.ButtonTitle
  let onTap: (() -> Void)?
  let showButton: Bool
  
  public init(
    headerTitle: HeaderNamespace.HeaderTitle,
    buttonTitle: HeaderNamespace.ButtonTitle,
    showButton: Bool,
    onTap: @escaping () -> Void
  ) {
    self.headerTitle = headerTitle
    self.buttonTitle = buttonTitle
    self.showButton = showButton
    self.onTap = onTap
  }
}


extension ScrollViewHeader: View {
  public var body: some View {
    HStack(spacing: 0) {
      Text(headerTitle.rawValue)
        .font(.B1_SB)
        .foregroundStyle(.caption1)
        .padding(.leading, 6)
      Spacer()
      
      if showButton {
        Button {
          onTap?()
        } label: {
          HStack(spacing: 0) {
            Text(buttonTitle.rawValue)
              .font(.B2_M)
              .foregroundStyle(.caption1)
            Image(icon: Icon.smallChevronRight)
              .resizable()
              .frame(width: 20, height: 20)
          }
        }
      }
    }
  }
}

#Preview {
  ScrollViewHeader(
    headerTitle: .addLink,
    buttonTitle: .showMore,
    showButton: false
  ) {
    print("")
  }
}
