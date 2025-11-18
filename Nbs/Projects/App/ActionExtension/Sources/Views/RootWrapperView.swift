//
//  RootWrapperView.swift
//  Nbs
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

import SwiftData

import Domain
import DesignSystem

struct RootWrapperView: View {
  let container: ModelContainer
  let isURLExisting: Bool
  let saveAction: (CategoryItem?) -> Void
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      if isURLExisting {
        ReadyExistSheetView()
      } else {
        ShareBottomSheetView(saveAction: saveAction)
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .modelContainer(container)
    .ignoresSafeArea(edges: .bottom)
  }
}
