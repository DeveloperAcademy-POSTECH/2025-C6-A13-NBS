
//
//  CategorySettingView.swift
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
      Color.dim
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

struct CategorySettingView {
  @Bindable var store: StoreOf<CategorySettingFeature>
}

extension CategorySettingView: View {
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Color.clear
          .frame(width: 44, height: 44)
          .allowsHitTesting(false)
        Text("카테고리 편집")
          .font(.B1_SB)
          .foregroundStyle(.text1)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.vertical, 12)
        Button {
          store.send(.dismissButtonTapped)
        } label: {
          Image(icon: Icon.x)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(.icon)
            .padding(12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.trailing, 2)
      }
      .frame(height: 48)
      .padding(.top, 8)
      .padding(.bottom, 8)
      
      Button {
        store.send(.editButtonTapped)
      } label: {
        HStack(spacing: 0) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 40)
        .buttonStyle(.plain)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading)
      .padding(.bottom, 4)
      
      Button {
        store.send(.addButtonTapped)
      } label: {
        HStack(spacing: 0) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 40)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading)
      .padding(.vertical, 4)

      Button {
        store.send(.deleteButtonTapped)
      } label: {
        HStack(spacing: 0) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 40)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading)
      .padding(.vertical, 4)
      .padding(.bottom, 40)
    }
  }
}

#Preview {
  CategorySettingView(store: Store(initialState: CategorySettingFeature.State()) {
    CategorySettingFeature()
  })
}

