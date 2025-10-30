//
//  RootWrapperView.swift
//  Nbs
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

import SwiftData

import Domain

struct RootWrapperView: View {
  let container: ModelContainer
  let saveAction: (CategoryItem?) -> Void
  
  var body: some View {
    ShareBottomSheetView(saveAction: saveAction)
      .modelContainer(container)
      .ignoresSafeArea(edges: .bottom)
  }
}
