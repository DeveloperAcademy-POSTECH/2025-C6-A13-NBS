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
  
  public var sourcesPath: String {
    switch self {
    case .Nbs: return "Nbs/Sources/**"
    case .NbsTests: return "Nbs/Tests/**"
    case .SafariExtension: return "SafariExtension/Sources/**"
    }
  }
  
  public var resourcesPath: String {
    switch self {
    case .Nbs: return "Nbs/Resources/**"
    case .NbsTests: return ""
    case .SafariExtension: return "SafariExtension/Resources/**"
    }
  }
}
