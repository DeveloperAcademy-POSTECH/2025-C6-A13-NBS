
//
//  SettingView.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct BottomSheetContainerView<Content: View>: View {
  let content: Content
  let onDismiss: () -> Void
  
  @State private var offset: CGFloat = UIScreen.main.bounds.height
  
  init(
    onDismiss: @escaping () -> Void,
    @ViewBuilder content: () -> Content
  ) {
    self.onDismiss = onDismiss
    self.content = content()
  }
  
  var body: some View {
    ZStack {
      Color.black
        .opacity(0.3)
        .ignoresSafeArea(.all)
        .onTapGesture {
          dismiss()
        }
      
      VStack {
        Spacer()
        content
          .frame(maxWidth: .infinity)
          .background(DesignSystemAsset.background.swiftUIColor)
          .cornerRadius(16)
          .offset(y: offset)
      }
    }
    .ignoresSafeArea(.all)
    .onAppear {
      withAnimation(.default) {
        offset = 0
      }
    }
  }
  
  private func dismiss() {
    withAnimation(.spring()) {
      offset = UIScreen.main.bounds.height
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      onDismiss()
    }
  }
}

struct SettingView {
  @Bindable var store: StoreOf<SettingFeature>
}

extension SettingView: View {
  var body: some View {
    VStack {
      Text(store.message)
        .font(.title)
        .padding()
      Button("Dismiss") {
        store.send(.dismissButtonTapped)
      }
    }
  }
}

#Preview {
  SettingView(store: Store(initialState: SettingFeature.State()) {
    SettingFeature()
  })
}
