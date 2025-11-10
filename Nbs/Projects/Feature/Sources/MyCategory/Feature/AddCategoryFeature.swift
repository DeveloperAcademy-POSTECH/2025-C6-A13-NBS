
import ComposableArchitecture
import Domain
import SwiftUI

extension Notification.Name {
  static let categoryAdded = Notification.Name("categoryAdded")
}

@Reducer
struct AddCategoryFeature {
  @ObservableState
  struct State: Equatable {
    var categoryName: String = ""
    var selectedIcon: CategoryIcon = .init(number: 1)
    var isAlert: Bool = false
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case saveButtonTapped
    case cancelButtonTapped
    case backGestureSwiped
    case confirmAlertDismissed
    case confirmAlertConfirmButtonTapped
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
          NotificationCenter.default.post(name: .categoryAdded, object: nil)
          await linkNavigator.pop()
        }
      case .binding:
        return .none
      case .backGestureSwiped, .cancelButtonTapped:
        state.isAlert = true
        return .none
      case .confirmAlertDismissed:
        state.isAlert = false
        return .none
      case .confirmAlertConfirmButtonTapped:
        return .run { _ in await linkNavigator.pop() }
      }
    }
  }
}
