//
//  TextField.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI

struct NBTextField {
  @State var isFocused: Bool = false
  @State var isError: Bool = false
  @State var isDisabled: Bool = false
  @State var isFilled: Bool = false
  @State var text: String = ""
}

extension NBTextField: View {
  var body: some View {
    TextField("링크를 입력해 주세요", text: $text)
      .font(.B1_M)
      .padding(.all)
      .frame(height: 56)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .stroke(.divider1, lineWidth: 1)
      )
      .padding(.horizontal, 16)
  }
}

#Preview {
  NBTextField()
}
