
import SwiftUI
import ComposableArchitecture
import DesignSystem

struct AddCategoryView: View {
  @Bindable var store: StoreOf<AddCategoryFeature>
  
  var body: some View {
    NavigationStack {
      VStack {
        TextField("Category Name", text: $store.categoryName)
          .textFieldStyle(.roundedBorder)
          .padding()
        
        // 아이콘 선택 뷰 (나중에 추가)
        
        Spacer()
      }
      .navigationTitle("New Category")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            store.send(.cancelButtonTapped)
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            store.send(.saveButtonTapped)
          }
          .disabled(store.categoryName.isEmpty)
        }
      }
    }
  }
}
