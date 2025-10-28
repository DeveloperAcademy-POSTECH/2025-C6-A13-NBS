
import SwiftUI

import ComposableArchitecture
import DesignSystem

struct AddCategoryView: View {
  @Bindable var store: StoreOf<AddCategoryFeature>
  @FocusState private var isFocused: Bool
  
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
        VStack(alignment: .leading, spacing: 4) {
          TextField(
            CategoryNamespace.categoryTextfieldPlaceHolder,
            text: $store.categoryName
          )
          .focused($isFocused)
          .onChange(of: store.categoryName) { _, newValue in
            if newValue.count > 14 {
              store.categoryName = String(newValue.prefix(14))
            }
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(DesignSystemAsset.n0.swiftUIColor)
              .stroke(Color.divider1, lineWidth: 1)
          )
          .padding(.top, 8)
          .padding(.horizontal, 20)
          
          HStack {
            Spacer()
            Text("\(store.categoryName.count)/14")
              .font(.C3)
              .foregroundStyle(store.categoryName.count == 14 ? .caption3 : .caption2)
              .padding(.trailing, 24)
          }
        }
        
        Text(CategoryNamespace.categoryIcon)
          .font(.B2_SB)
          .foregroundStyle(.caption1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 24)
          .padding(.top, 24)
        
        ScrollView {
          LazyVGrid(columns: columns, spacing: 10) {
            ForEach(1..<16, id: \.self) { index in
              let isSelected = store.selectedIcon.number == index
              
              Button {
                store.selectedIcon = .init(number: index)
              } label: {
                RoundedRectangle(cornerRadius: 12)
                  .fill(
                    isSelected
                    ? DesignSystemAsset.bl1.swiftUIColor
                    : DesignSystemAsset.color(number: index)
                  )
                  .overlay(
                    RoundedRectangle(cornerRadius: 12)
                      .strokeBorder(
                        isSelected
                        ? DesignSystemAsset.bl6.swiftUIColor
                        : Color.clear,
                        lineWidth: 1.25
                      )
                  )
                  .aspectRatio(1, contentMode: .fit)
                  .overlay(
                    DesignSystemAsset.categoryIcon(number: index)
                      .resizable()
                      .frame(width: 45, height: 45)
                  )
              }
              .buttonStyle(.plain)
              .disabled(isFocused)
            }
          }
          .padding(.horizontal, 20)
        }
        .scrollDisabled(isFocused)
        .padding(.top, 4)
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
    .onTapGesture {
      isFocused = false
    }
    .toolbar(.hidden)
    .ignoresSafeArea(.keyboard)
  }
}

#Preview {
  AddCategoryView(store: Store(initialState: AddCategoryFeature.State()) {
    AddCategoryFeature()
  })
}
