
//
//  AddLinkView.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI
import ComposableArchitecture

struct AddLinkView: View {
  
  let store: StoreOf<AddLinkFeature>
  
  var body: some View {
    VStack {
      TopAppBarDefaultRightIconxFeatureView(
        store: store.scope(
          state: \.topAppBar,
          action: \.topAppBar
        )
      )
      
      Text(AddLinkNamespace.addLink)
        .font(.B2_SB)
        .foregroundStyle(.caption1)
      
      Spacer()
    }
    .navigationBarHidden(true)
  }
}

#Preview {
  AddLinkView(store: Store(initialState: AddLinkFeature.State()) {
    AddLinkFeature()
  })
}
