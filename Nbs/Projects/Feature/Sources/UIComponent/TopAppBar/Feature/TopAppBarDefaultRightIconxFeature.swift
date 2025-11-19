//
//  TopAppBarDefaultRightIconxFeature.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

@Reducer
public struct TopAppBarDefaultRightIconxFeature {
  public struct State: Equatable {
    public var title: String
    public init(title: String) {
      self.title = title
    }
  }

  public enum Action: Equatable {
    case tapBackButton
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tapBackButton:
        return .none
      }
    }
  }
}
