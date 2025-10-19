//
//  MyCategoryCollection.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct MyCategoryCollectionView {
  let store: StoreOf<MyCategoryCollectionFeature>
}

extension MyCategoryCollectionView: View {
  var body: some View {
    Text("Hello world!")
  }
}
