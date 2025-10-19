//
//  CategoryGridView.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct CategoryGridView {
  let store: StoreOf<CategoryGridFeature>
}

extension CategoryGridView: View {
  var body: some View {
    Text("안녕하세요")
  }
}
