//
//  Separator.swift
//  Nbs
//
//  Created by 여성일 on 10/18/25.
//

import SwiftUI

struct Separator: View {
  var body: some View {
    Rectangle()
      .frame(width: 44, height: 4)
      .foregroundStyle(.gray)
      .clipShape(.capsule)
  }
}

#Preview {
  Separator()
}
