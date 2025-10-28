//
//  TargetDependency+Library.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

extension TargetDependency {
  public static func TCA() -> TargetDependency {
    .external(name: "ComposableArchitecture")
  }
  
  public static func LinkNavigator() -> TargetDependency {
    .external(name: "LinkNavigator")
  }
}
