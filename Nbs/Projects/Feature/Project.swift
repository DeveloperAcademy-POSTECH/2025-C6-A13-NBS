//
//  Project.swift
//  Manifests
//
//  Created by Hong on 10/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let protject = Project.project(
  name: Module.Feature.rawValue,
  targets: [
    Target.target(
      name: Module.Feature.rawValue,
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .TCA()
      ]
    )
  ]
)
