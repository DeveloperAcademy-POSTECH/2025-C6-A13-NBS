//
//  TargetName.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

public enum TargetName: String {
  case Nbs
  case NbsTests
  case SafariExtension
  case ShareExtension
  
  public var sourcesPath: String {
    switch self {
    case .Nbs: return "Nbs/Sources/**"
    case .NbsTests: return "Nbs/Tests/**"
    case .SafariExtension: return "SafariExtension/Sources/**"
    case .ShareExtension: return "ShareExtension/Sources/**"
    }
  }
  
  public var resourcesPath: String {
    switch self {
    case .Nbs: return "Nbs/Resources/**"
    case .NbsTests: return ""
    case .SafariExtension: return "SafariExtension/Resources/**"
    case .ShareExtension: return "ShareExtension/Resources/**"
    }
  }
}
