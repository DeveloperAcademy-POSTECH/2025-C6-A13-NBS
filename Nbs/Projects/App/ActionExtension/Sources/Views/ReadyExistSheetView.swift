//
//  ReadyExistSheetView.swift
//  ActionExtension
//
//  Created by 여성일 on 10/30/25.
//

import SwiftUI
import UIKit

import DesignSystem

// MARK: - Properties
struct ReadyExistSheetView: View {
}

// MARK: - View
extension ReadyExistSheetView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(alignment: .leading, spacing: 0) {
        HStack {
          Spacer()
          Separator()
          Spacer()
        }
        headerView
        Spacer()
        MainButton("닫기") {
          NotificationCenter.default.post(name: .closeShareExtension, object: nil)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
      }
      .padding(.top, 8)
    }
    .frame(minHeight: 308)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
  
  private var headerView: some View {
    Text("이미 저장된 링크예요!")
      .font(.B1_SB)
      .foregroundStyle(.text1)
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
  }
}


#Preview {
    ReadyExistSheetView()
}
