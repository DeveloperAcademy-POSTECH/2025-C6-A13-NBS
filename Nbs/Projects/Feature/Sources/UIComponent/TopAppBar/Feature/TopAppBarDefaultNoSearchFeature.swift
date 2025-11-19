//
//  TopAppBarDefaultNoSearchFeature.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

@Reducer
public struct TopAppBarDefaultNoSearchFeature {
  public struct State: Equatable {
    public var title: String
    public init(title: String) {
      self.title = title
    }
  }
  
  public enum Action: Equatable {
    case tapBackButton
    case tapSettingButton
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tapBackButton:
        return .none
      case .tapSettingButton:
        return .none
      }
    }
  }
}
