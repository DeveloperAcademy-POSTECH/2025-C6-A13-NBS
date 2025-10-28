
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
          try swiftDataClient.addCategory(newCategory)
          await linkNavigator.pop()
        }
      case .cancelButtonTapped:
        return .run { _ in await linkNavigator.pop() }
      case .binding:
        return .none
      }
    }
  }
}
