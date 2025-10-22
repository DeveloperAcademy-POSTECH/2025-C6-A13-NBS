////
////  DeleteLinkFeature.swift
////  Feature
////
////  Created by 이안 on 10/22/25.
////
//
//import SwiftUI
//import ComposableArchitecture
//import Domain
//
//@Reducer
//struct DeleteLinkFeature {
//  @ObservableState
//  struct State: Equatable {
//    var link: LinkItem
//    var showConfirmation: Bool = true
//  }
//
//  enum Action {
//    case confirmDelete
//    case cancel
//    case delegate(Delegate)
//    
//    enum Delegate {
//      case dismissed
//      case deletedSuccessfully
//    }
//  }
//
//  @Dependency(\.swiftDataClient) var swiftDataClient
//
//  var body: some ReducerOf<Self> {
//    Reduce { state, action in
//      switch action {
//      case .cancel:
//        return .send(.delegate(.dismissed))
//      case .confirmDelete:
//        return .run { send in
//          try await swiftDataClient.deleteLink(state.link)
//          await send(.delegate(.deletedSuccessfully))
//        }
//      case .delegate:
//        return .none
//      }
//    }
//  }
//}
