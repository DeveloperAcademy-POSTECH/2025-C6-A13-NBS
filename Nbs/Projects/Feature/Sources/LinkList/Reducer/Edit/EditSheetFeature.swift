//
//  EditSheetFeature.swift
//  Feature
//
//  Created by 이안 on 10/21/25.
//

import SwiftUI
import ComposableArchitecture
import Domain

@Reducer
struct EditSheetFeature {
  @ObservableState
  struct State: Equatable {
    var link: ArticleItem?
  }
  
  enum Action {
    case dismissButtonTapped
    case moveButtonTapped
    case deleteButtonTapped
    case delegate(Delegate)
    
    enum Delegate {
      case dismissSheet
      case moveLink(ArticleItem?)
      case deleteLink(ArticleItem?)
    }
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissButtonTapped:
        return .send(.delegate(.dismissSheet))
        
      case .moveButtonTapped:
        return .send(.delegate(.moveLink(state.link)))
        
      case .deleteButtonTapped:
        return .send(.delegate(.deleteLink(state.link)))
        
      case .delegate:
        return .none
      }
    }
  }
}
