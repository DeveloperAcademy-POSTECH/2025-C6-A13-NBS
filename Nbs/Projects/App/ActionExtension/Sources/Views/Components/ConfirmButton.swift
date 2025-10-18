//
//  ConfirmButton.swift
//  Nbs
//
//  Created by 여성일 on 10/18/25.
//

import SwiftUI

import DesignSystem

// MARK: - Properties
struct ConfirmButton: View {
  let title: String
  let isOn: Bool
  let action: (() -> Void)?
  
  init(
    title: String = "확인",
    isOn: Bool = true,
    action: @escaping () -> Void,
  ) {
    self.title = title
    self.isOn = isOn
    self.action = action
  }
}

// MARK: - View
extension ConfirmButton {
  var body: some View {
    Button {
      action?()
    } label: {
      Text(title)
        .font(.B2_SB)
        .foregroundStyle(isOn ? .textw : .caption2)
        .frame(width: 56, height: 36)
        .background(isOn ? .bl6 : .n40)
        .clipShape(.capsule)
    }
    .buttonStyle(.plain)
    .disabled(!isOn) 
  }
}

#Preview {
  ConfirmButton(action: {})
}
