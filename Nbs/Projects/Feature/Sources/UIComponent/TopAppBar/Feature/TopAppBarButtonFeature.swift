//
//  TopAppBarButtonFeature.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

@Reducer
public struct TopAppBarButtonFeature {
  public struct State: Equatable {
    public var isEditing = false
    public init() {}
  }
  
  public enum Action: Equatable {
    case tapEditButton
    case tapBackButton
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tapEditButton:
        state.isEditing.toggle()
        return .none
        
      case .tapBackButton:
        return .none
      }
    }
  }
}
