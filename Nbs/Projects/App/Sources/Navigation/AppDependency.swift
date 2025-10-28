//
//  AppDependency.swift
//  Nbs
//
//  Created by 홍 on 10/26/25.
//

import LinkNavigator
import SwiftData
import Domain

public struct AppDependency: DependencyType, HasModelContainer {
  public let modelContainer: ModelContainer

  public init(modelContainer: ModelContainer) {
    self.modelContainer = modelContainer
  }
}
