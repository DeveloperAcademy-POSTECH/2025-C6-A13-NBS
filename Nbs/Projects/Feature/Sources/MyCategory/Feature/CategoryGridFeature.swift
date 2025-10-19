//
//  CategoryGridFeature.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import ComposableArchitecture

@Reducer
struct CategoryGridFeature {
  struct State: Equatable {}
  enum Action {}
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      return .none
    }
  }
}
