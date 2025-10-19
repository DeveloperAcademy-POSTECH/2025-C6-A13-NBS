
import ComposableArchitecture
import Domain

@Reducer
struct AddCategoryFeature {
  @ObservableState
  struct State: Equatable {
    var categoryName: String = ""
    var selectedIcon: CategoryIcon = .init(number: 1)
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case saveButtonTapped
    case cancelButtonTapped
    case delegate(Delegate)
    
    enum Delegate {
      case categorySaved(CategoryItem)
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .saveButtonTapped:
        let newCategory = CategoryItem(categoryName: state.categoryName, icon: state.selectedIcon)
        return .run {
          send in
          await send(.delegate(.categorySaved(newCategory)))
          await self.dismiss()
        }
      case .cancelButtonTapped:
        return .run { _ in await self.dismiss() }
      case .binding, .delegate:
        return .none
      }
    }
  }
}
