//
//  DeleteLinkFeature.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI

import SwiftData
import ComposableArchitecture
import Domain

@Reducer
struct DeleteLinkFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var allLinks: [ArticleItem] = []
    var categoryName: String = "전체"
    var selectedLinks: Set<String> = []
    var isSelectAll: Bool = false
    var hideSelectControls: Bool = false
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case onAppear
    case toggleSelect(ArticleItem)
    case backButtonTapped
    case confirmDeleteTapped
    case delegate(Delegate)
    case deleteDone(Int)
    
    enum Delegate {
      case dismiss
      case confirmDelete(selected: [ArticleItem])
    }
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        if state.hideSelectControls {
          state.selectedLinks = Set(state.allLinks.map(\.id))
          state.isSelectAll = true
        }
        return .none
        
        /// 전체 선택 or 해제
      case .binding(\.isSelectAll):
        if state.isSelectAll {
          state.selectedLinks = Set(state.allLinks.map(\.id))
        } else {
          state.selectedLinks.removeAll()
        }
        return .none
        
        /// 개별 토글 시 전체선택 여부 갱신
      case let .toggleSelect(link):
        if state.selectedLinks.contains(link.id) {
          state.selectedLinks.remove(link.id)
        } else {
          state.selectedLinks.insert(link.id)
        }
        state.isSelectAll = state.selectedLinks.count == state.allLinks.count
        return .none
        
      case .backButtonTapped:
        return .run { _ in
          await linkNavigator.pop()
        }
        
      case .confirmDeleteTapped:
        let selectedIDs = state.allLinks
          .filter { state.selectedLinks.contains($0.id) }
          .map(\.id)
        
        guard !selectedIDs.isEmpty else {
          return .none
        }
        
        return .run { _ in
          do {
            for id in selectedIDs {
              try swiftDataClient.deleteLinkById(id)
            }
            
            NotificationCenter.default.post(
              name: .linkDeleted,
              object: ["deletedCount": selectedIDs.count]
            )
            
            try? await Task.sleep(nanoseconds: 400_000_000)
            await linkNavigator.pop()
            
          } catch {
            print("delete by ids failed:", error)
          }
        }
        
      case .deleteDone:
        return .run { _ in
          await linkNavigator.pop()
        }
        
      case .binding, .delegate:
        return .none
      }
    }
  }
}

extension Notification.Name {
  static let linkDeleted = Notification.Name("linkDeleted")
}
