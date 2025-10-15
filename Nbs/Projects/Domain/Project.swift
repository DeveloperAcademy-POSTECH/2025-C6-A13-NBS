//
//  Project.swift
//  Manifests
//
//  Created by 홍 on 10/15/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let protject = Project.project(
  name: Module.Domain.rawValue,
  targets: [
    Target.target(
      name: Module.Domain.rawValue,
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
      
      ]
    )
  ]
)
