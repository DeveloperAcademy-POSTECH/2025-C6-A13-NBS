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
  struct State: Equatable {
    @BindingState var searchText: String = ""
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case backTapped
    case submit
    case clear
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .backTapped:
        print("뒤로가기 클릭됨")
        return .none
        
      case .submit:
        print("검색 실행: \(state.searchText)")
        return .none
        
      case .clear:
        state.searchText = ""
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}
