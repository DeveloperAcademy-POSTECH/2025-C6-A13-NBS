//
//  PolicyDetailView.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import Domain

struct PolicyDetailView: View {
  @Bindable var store: StoreOf<PolicyDetailFeature>
}

extension PolicyDetailView {
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack(spacing: .zero) {
        TopAppBarDefaultRightIconx(title: store.title) {
          store.send(.backButtonTapped)
        }
        
        ScrollView {
          Text(.init(store.text))
            .font(.C2)
            .foregroundStyle(.caption2)
            .padding(20)
        }
      }
    }
  }
}
