//
//  AddCategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import DesignSystem

extension Notification.Name {
  static let categoryAdded = Notification.Name("categoryAdded")
}

@Reducer
struct AddCategoryFeature {
  
  @Dependency(\.linkNavigator) var linkNavigator
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    var categoryName: String = ""
    var selectedIcon: CategoryIcon = .init(number: 1)
    var isAlert: Bool = false
    var textFieldStyle: JNTextFieldStyle = .default
    var isDuplicate: Bool = false
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case saveButtonTapped
    case cancelButtonTapped
    case backGestureSwiped
    case confirmAlertDismissed
    case confirmAlertConfirmButtonTapped
    case setDuplicate(Bool)
    case setTextFieldStyle(JNTextFieldStyle)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.categoryName):
        state.isDuplicate = false
        state.textFieldStyle = .default
        return .none
        
      case .saveButtonTapped:
        return .run { [name = state.categoryName] send in
          let categories = try swiftDataClient.fetchCategories()
          let isDuplicate = categories.contains { $0.categoryName.lowercased() == name.lowercased() } ||
            name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "전체"
          await send(.setDuplicate(isDuplicate))
        }
        
      case .setDuplicate(let isDuplicate):
        state.isDuplicate = isDuplicate
        state.textFieldStyle = isDuplicate ? .errorCaption : .default
        
        if !isDuplicate {
          let newCategory = CategoryItem(
            categoryName: state.categoryName,
            icon: state.selectedIcon
          )
          return .run { _ in
            try swiftDataClient.addCategory(newCategory)
            NotificationCenter.default.post(name: .categoryAdded, object: nil)
            await linkNavigator.pop()
          }
        } else {
          return .none
        }
        
      case .setTextFieldStyle(let style):
        state.textFieldStyle = style
        return .none
        
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
