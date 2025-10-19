//
//  AddLinkView.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct AddLinkView: View {
  
  @Bindable var store: StoreOf<AddLinkFeature>
  
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
        .padding(.top, 8)
      
      TextField(
        AddLinkNamespace.placeHoler,
        text: $store.linkURL.sending(\.setLinkURL)
      )
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(DesignSystemAsset.n0.swiftUIColor)
          .stroke(Color.divider1, lineWidth: 1)
      )
      .padding(.top, 8)
      .padding(.horizontal, 20)
      
      HStack {
        Text(AddLinkNamespace.selectCategory)
          .font(.B2_SB)
          .foregroundStyle(.caption1)
        Spacer()
        
        AddNewCategoryButton(action: {
            store.send(.addNewCategoryButtonTapped)
        })
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 24)
      .padding(.top, 24)
      
      
      MainButton(AddLinkNamespace.ctaButtonTitle) {
        store.send(.saveButtonTapped)
      }
      .padding(.horizontal, 20)
    }
    .ignoresSafeArea(.keyboard)
    .navigationBarHidden(true)
    .background(DesignSystemAsset.background.swiftUIColor)
  }
}

#Preview {
  AddLinkView(store: Store(initialState: AddLinkFeature.State()) {
    AddLinkFeature()
  })
}
