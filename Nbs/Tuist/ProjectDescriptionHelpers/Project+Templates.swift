//
//  Project+Templates.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

extension Project {
  public static let bundleID = "com.Nbs.ADA"
  public static let iosVersion = "17.0"
  public static let appName = "Nbs"
}

extension Project {
  public static func project(
    name: String,
    targets: [Target] = [],
    additionalFiles: [FileElement] = []
  ) -> Project {
    Project(
      name: name,
      options: .options(
        textSettings: .textSettings(
          indentWidth: 2,
          tabWidth: 2,
          wrapsLines: true
        )
      ),
      targets: targets,
      additionalFiles: additionalFiles
    )
  }
}
