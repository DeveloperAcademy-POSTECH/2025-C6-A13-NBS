//
//  TopAppBarSearchFeature.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

@Reducer
struct TopAppBarSearchFeature {
  @ObservableState
  struct State: Equatable {
    var searchText: String = ""
    var isSearchFieldFocused: Bool = false
  }
  
  enum Action: BindableAction, Equatable {
    case backTapped
    case submit
    case clear
    case setSearchFieldFocus(Bool)
    case setSearchText(String)
    
    case delegate(DelegateAction)
    case binding(BindingAction<State>)
  }
  
  enum DelegateAction: Equatable {
    case searchTriggered(query: String)
    case searchQueryChanged(String)
    case backButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
      .onChange(of: \.searchText) { oldValue, newValue in
        Reduce { state, action in
            .send(.delegate(.searchQueryChanged(newValue)))
        }
      }
    
    Reduce { state, action in
      switch action {
      case .backTapped:
        return .send(.delegate(.backButtonTapped))
        
      case .submit:
        return .send(.delegate(.searchTriggered(query: state.searchText)))
        
      case .clear:
        state.searchText = ""
        return .none
        
      case .setSearchFieldFocus(let isFocused):
        state.isSearchFieldFocused = isFocused
        return .none
        
      case let .setSearchText(text):
        state.searchText = text
        return .none
        
      case .delegate, .binding:
        return .none
      }
    }
  }
}
