//
//  Target+Templates.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

extension Target {
  public static func target (
    name: String,
    product: Product,
    bundleId: String? = nil,
    infoPlist: InfoPlist? = .default,
    sources: SourceFilesList? = nil,
    resources: ResourceFileElements? = nil,
    entitlements: Entitlements? = nil,
    scripts: [TargetScript] = [],
    dependencies: [TargetDependency] = [],
    settings: Settings? = nil
  ) -> Target {
    
    let signing = Target.signingSettings(for: product, name: name)
    
    return Target.target(
      name: name,
      destinations: .init([.iPhone]),
      product: product,
      bundleId: bundleId ?? Project.bundleID + "." + name.lowercased(),
      deploymentTargets: .iOS(Project.iosVersion),
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies,
      settings: .settings(
        base: signing.base,
        configurations: signing.configs
      )
    )
  }
}

extension SourceFilesList {
  public static let sources: SourceFilesList = ["Sources/**"]
  public static let tests: SourceFilesList = ["Tests/**"]
}

extension Target {
  private static func signingSettings(for product: Product, name: String)
    -> (base: [String: SettingValue], configs: [Configuration]) {
    
    switch product {
    case .framework:
      return (
        base: [
          "CODE_SIGN_STYLE": "Automatic",
          "DEVELOPMENT_TEAM": "WN2B884S76"
        ],
        configs: [
          .debug(name: "Debug", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.dev.ADA.\(name.lowercased())"
          ]),
          .release(name: "Release", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.ADA.\(name.lowercased())"
          ])
        ]
      )
      
    case .app:
      return (
        base: [
          "CODE_SIGN_STYLE": "Manual",
          "DEVELOPMENT_TEAM": "WN2B884S76"
        ],
        configs: [
          .debug(name: "Debug", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.dev.ADA.app",
            "PROVISIONING_PROFILE_SPECIFIER": "match Development com.Nbs.dev.ADA.*",
            "CODE_SIGN_IDENTITY": "Apple Development: Yunhong Kim (Q7CMJ86WZQ)"
          ]),
          .release(name: "Release", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.ADA.app",
            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.Nbs.ADA.*",
            "CODE_SIGN_IDENTITY": "Apple Distribution: Yunhong Kim (WN2B884S76)"
          ])
        ]
      )
      
    default:
      return (
        base: [
          "CODE_SIGN_STYLE": "Automatic",
          "DEVELOPMENT_TEAM": "WN2B884S76"
        ],
        configs: [
          .debug(name: "Debug", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.dev.ADA.\(name.lowercased())"
          ]),
          .release(name: "Release", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.ADA.\(name.lowercased())"
          ])
        ]
      )
    }
  }
}
