//
//  TargetDependency+Module.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

extension TargetDependency {
  public static func feature() -> TargetDependency {
    .project(target: "Feature", path: .relativeToRoot("Projects/Feature"))
  }
}

extension TargetDependency {
  public static func designSystem() -> TargetDependency {
    .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem"))
  }
}

extension TargetDependency {
  public static func safariEx() -> TargetDependency {
    .target(name: TargetName.SafariExtension.rawValue)
  }
}

