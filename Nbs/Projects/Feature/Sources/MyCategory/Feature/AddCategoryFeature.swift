
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
  }
  
  @Dependency(\.linkNavigator) var linkNavigator
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .saveButtonTapped:
        let newCategory = CategoryItem(
          categoryName: state.categoryName,
          icon: state.selectedIcon
        )
        return .run {
          send in
          try await swiftDataClient.addCategory(newCategory)
          linkNavigator.pop()
        }
      case .cancelButtonTapped:
        linkNavigator.pop()
        return .none
      case .binding:
        return .none
      }
    }
  }
}
