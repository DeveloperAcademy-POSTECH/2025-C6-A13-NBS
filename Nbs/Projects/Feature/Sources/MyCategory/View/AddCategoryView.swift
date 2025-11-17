
import SwiftUI

import ComposableArchitecture
import DesignSystem

struct AddCategoryView {
  @Bindable var store: StoreOf<AddCategoryFeature>
  @FocusState private var isFocused: Bool
  
  let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]
}

extension AddCategoryView: View {
  var body: some View {
    ZStack(alignment: .leading) {
      VStack(spacing: 8) {
        TopAppBarDefaultRightIconx(title: CategoryNamespace.newCategoryNavTitle) {
          store.send(.cancelButtonTapped)
        }
        
        JNTextField(
          text: $store.categoryName,
          style: $store.textFieldStyle.sending(\.setTextFieldStyle),
          placeholder: "카테고리명을 입력해주세요",
          caption: "이미 존재하는 카테고리예요",
          header: "카테고리명"
        )
        .focused($isFocused)
        
        Text(CategoryNamespace.categoryIcon)
          .font(.B2_SB)
          .foregroundStyle(.caption1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 24)
          .padding(.top)
        
        //TODO: 컴포넌트 대체하기
        ScrollView {
          LazyVGrid(columns: columns, spacing: 16) {
            ForEach(1..<16, id: \.self) { index in
              let isSelected = store.selectedIcon.number == index
              Button {
                store.selectedIcon = .init(number: index)
              } label: {
                RoundedRectangle(cornerRadius: 12)
                  .fill(
                    isSelected
                    ? DesignSystemAsset.bl1.swiftUIColor
                    : DesignSystemAsset.n0.swiftUIColor
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
                    DesignSystemAsset.primaryCategoryIcon(number: index)
                      .resizable()
                      .frame(width: 56, height: 56)
                  )
                  .animation(.easeInOut(duration: 0.2), value: isSelected)
              }
              .shadow(color: .bgShadow3, radius: 4, x: 0, y: 0)
              .buttonStyle(.plain)
              .disabled(isFocused)
            }
          }
          .padding(.horizontal, 20)
          .padding(.bottom, 32)
        }
        .scrollDisabled(isFocused)
        .scrollIndicators(.hidden)
        
        MainButton(
          CategoryNamespace.addCategory,
          isDisabled: store.categoryName.isEmpty,
          hasGradient: true
        ) {
          store.send(.saveButtonTapped)
        }
        .padding(.bottom, 8)
      }
      .contentShape(Rectangle())
      .onTapGesture {
        isFocused = false
      }
      .background(Color.background)
      
      Color.clear
        .frame(width: 50)
        .padding(.top, 60)
        .contentShape(Rectangle())
        .allowsHitTesting(false)
        .gesture(
          DragGesture()
            .onEnded { value in
              if value.translation.width > 80 {
                store.send(.backGestureSwiped)
              }
            }
        )
    }
    .toolbar(.hidden)
    .ignoresSafeArea(.keyboard)
    .overlay {
      if store.isAlert {
        ZStack {
          Color.dim.ignoresSafeArea()
          AlertDialog(
            title: "카테고리 추가를 중단할까요?",
            subtitle: "페이지를 나가면 카테고리가 저장되지 않아요",
            cancelTitle: "취소",
            onCancel: { store.send(.confirmAlertDismissed)},
            buttonType: .confirm(title: "나가기", action: {
              store.send(.confirmAlertConfirmButtonTapped)
            })
          )
        }
      }
    }
  }
}

#Preview {
  AddCategoryView(store: Store(initialState: AddCategoryFeature.State()) {
    AddCategoryFeature()
  })
}
