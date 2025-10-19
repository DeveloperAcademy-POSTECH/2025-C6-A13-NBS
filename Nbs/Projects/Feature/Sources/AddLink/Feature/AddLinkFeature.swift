//
//  AddLinkFeature.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AddLinkFeature {
  
  @Dependency(\.dismiss) var dismiss
  
  @ObservableState
  struct State: Equatable {
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: AddLinkNamespace.naviTitle)
    var linkURL: String
    
    init(linkURL: String = "") {
      self.linkURL = linkURL
    }
  }
  
  enum Action {
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
    case setLinkURL(String)
    case saveButtonTapped
    case addNewCategoryButtonTapped
    case delegate(Delegate)
    
    enum Delegate {
      case goToAddCategory
    }
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarDefaultRightIconxFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .topAppBar(.tapBackButton):
        return .run { _ in await self.dismiss() }
        
      case .topAppBar:
        return .none
        
      case let .setLinkURL(url):
        state.linkURL = url
        return .none
        
      case .saveButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case .addNewCategoryButtonTapped:
        return .send(.delegate(.goToAddCategory))
        
      case .delegate:
        return .none
      }
    }
  }
}