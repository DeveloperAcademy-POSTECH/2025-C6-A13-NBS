
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
      HStack {
        Color.clear
          .frame(width: 44, height: 44)
          .allowsHitTesting(false)
        Text("카테고리 편집")
          .font(.B1_SB)
          .foregroundStyle(.text1)
          .frame(maxWidth: .infinity, alignment: .center)
        Button {
          store.send(.dismissButtonTapped)
        } label: {
          Image(icon: Icon.x)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(.icon)
            .padding(10)
            .contentShape(Rectangle())
        }
      }
      
      Button {
        store.send(.editButtonTapped)
      } label: {
        HStack {
          Image(icon: Icon.edit)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(.icon)
            .padding(10)
            .contentShape(Rectangle())
          Text("수정하기")
            .font(.B1_M)
            .foregroundStyle(.text1)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
      
      Button {
        store.send(.addButtonTapped)
      } label: {
        HStack {
          Image(icon: Icon.circlePlus)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(.icon)
            .padding(10)
            .contentShape(Rectangle())
          Text("추가하기")
            .font(.B1_M)
            .foregroundStyle(.text1)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)

      Button {
        store.send(.deleteButtonTapped)
      } label: {
        HStack {
          Image(icon: Icon.trash)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(.danger)
            .padding(10)
            .contentShape(Rectangle())
          Text("삭제하기")
            .font(.B1_M)
            .foregroundStyle(.danger)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
      .padding(.bottom, 44)
    }
  }
}

#Preview {
  SettingView(store: Store(initialState: SettingFeature.State()) {
    SettingFeature()
  })
}

