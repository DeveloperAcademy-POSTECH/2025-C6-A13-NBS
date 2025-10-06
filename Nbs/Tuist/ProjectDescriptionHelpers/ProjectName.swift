//
//  ProjectName.swift
//  Manifests
//
//  Created by Hong on 10/5/25.
//

import ProjectDescription

public enum Module: String {
  case App
  case Feature
  case DesignSystem
}

extension Module: CaseIterable {}
