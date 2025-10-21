
import SwiftUI

import ComposableArchitecture
import DesignSystem

struct AddCategoryView: View {
  @Bindable var store: StoreOf<AddCategoryFeature>
  
  let columns = [
    GridItem(.flexible(), spacing: 10),
    GridItem(.flexible(), spacing: 10),
    GridItem(.flexible(), spacing: 10)
  ]
  
  var body: some View {
    VStack {
      TopAppBarDefaultRightIconx(title: CategoryNamespace.newCategoryNavTitle) {
        //TODO: 알럿 추가하기
        store.send(.cancelButtonTapped)
      }
      VStack {
        Text(CategoryNamespace.categoryName)
          .font(.B2_SB)
          .foregroundStyle(.caption1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 24)
          .padding(.top, 8)
        TextField(
          CategoryNamespace.categoryTextfieldPlaceHolder,
          text: $store.categoryName
        )
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(DesignSystemAsset.n0.swiftUIColor)
            .stroke(Color.divider1, lineWidth: 1)
        )
        .padding(.top, 8)
        .padding(.horizontal, 20)
        
        Text(CategoryNamespace.categoryIcon)
          .font(.B2_SB)
          .foregroundStyle(.caption1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 24)
          .padding(.top, 24)
        
        ScrollView {
          LazyVGrid(columns: columns, spacing: 10) {
            ForEach(1..<16, id: \.self) { index in
              Button {
                store.selectedIcon = .init(number: index + 1)
              } label: {
                RoundedRectangle(cornerRadius: 12)
                  .fill(DesignSystemAsset.color(number: index))
                  .aspectRatio(1, contentMode: .fit)
                  .overlay(
                    DesignSystemAsset.categoryIcon(number: index)
                      .resizable()
                      .frame(width: 45, height: 55)
                  )
              }
              .buttonStyle(.plain)
            }
          }
          .padding(.horizontal, 20)
        }
        MainButton(
          CategoryNamespace.addCategory,
          isDisabled: store.categoryName.isEmpty
        ) {
          store.send(.saveButtonTapped)
        }
        .padding(.horizontal, 20)
      }
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .toolbar(.hidden)
    .ignoresSafeArea(.keyboard)
  }
}

#Preview {
  AddCategoryView(store: Store(initialState: AddCategoryFeature.State()) {
    AddCategoryFeature()
  })
}
