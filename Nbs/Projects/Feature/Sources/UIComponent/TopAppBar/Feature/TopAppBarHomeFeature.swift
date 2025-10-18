//
//  TopAppBarHomeFeature.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

@Reducer
public struct TopAppBarHomeFeature {
  public struct State: Equatable {
    
  }
  
  public enum Action: Equatable {
    case tapSearchButton
    case tapSettingButton
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tapSearchButton:
        return .none
      case .tapSettingButton:
        return .none
      }
    }
  }
}
