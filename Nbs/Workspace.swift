//
//  Workspace.swift
//  Manifests
//
//  Created by Hong on 10/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
  name: "NBS",
  projects:
    Module.allCases.map { module in
        "Projects/\(module.rawValue)"
    }
)
