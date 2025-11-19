//
//  SettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import Foundation

import ComposableArchitecture
import Domain

@Reducer
struct SettingFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable { }
  
  enum Action: Equatable {
    case backButtonTapped
    case privacyPolicyTapped
    case termsOfServiceTapped
    case openSourceTapped
    case safariTipTapped
    case highlightTipTapped
    case shareTipTapped
    case favoriteTipTapped
    case openLinkTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { _ in
          await linkNavigator.pop()
        }
        
      case .privacyPolicyTapped:
        linkNavigator.push(
          .policyDetail,
          PolicyDetailPayload(
            title: "개인정보 처리방침",
            text: Constants.AppInfo.privacyPolicy
          )
        )
        return .none
        
      case .termsOfServiceTapped:
        linkNavigator.push(
          .policyDetail,
          PolicyDetailPayload(
            title: "서비스 이용약관",
            text: Constants.AppInfo.termsOfService
          )
        )
        return .none
        
      case .openSourceTapped:
        linkNavigator.push(.openSourceList, nil)
        return .none
        
      case .safariTipTapped:
        linkNavigator.push(.extensionSetting, nil)
        return .none
        
      case .highlightTipTapped:
        linkNavigator.push(.onboardingHighlight, Route.home)
        return .none
        
      case .shareTipTapped:
        linkNavigator.push(.shareSetting, nil)
        return .none
        
      case .favoriteTipTapped:
        linkNavigator.push(.favoriteSetting, nil)
        return .none
        
      case .openLinkTapped:
        return .none
      }
    }
  }
}
