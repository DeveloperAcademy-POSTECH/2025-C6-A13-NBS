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
      Color(uiColor: .systemBackground).ignoresSafeArea()
      VStack(alignment: .leading, spacing: 0) {
        HStack {
          Spacer()
          Separator()
          Spacer()
        }
        headerView
        
        HStack {
          Spacer()
          DesignSystemAsset.resavedImage.swiftUIImage
            .frame(width: 97, height: 89)
            .padding(.vertical, 10)
          Spacer()
        }
        .frame(height: 109)
        .padding(.bottom, 19)

        MainButton("앱으로 바로가기") {
          NotificationCenter.default.post(name: .openAppAndCloseExtension, object: nil)
        }
        .buttonStyle(.plain)
        Spacer()
      }
      .padding(.top, 8)
    }
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
  
  private var headerView: some View {
    Text("저장된 링크는 앱에서 수정이 가능해요")
      .font(.B1_SB)
      .foregroundStyle(.text1)
      .frame(height: 34)
      .padding(.horizontal, 20)
      .padding(.vertical, 19)
  }
}


#Preview {
  ReadyExistSheetView()
}
