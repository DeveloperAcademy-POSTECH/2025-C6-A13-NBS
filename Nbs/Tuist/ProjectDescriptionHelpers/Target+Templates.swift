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
    destinations: Destinations? = nil,
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
      destinations: destinations ?? .init([.iPhone]),
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
    let baseBundleId = "com.Nbs"
    let bundleIdName = name == "SafariExtension" ? "safariExtension" : "shareExtension"
    switch product {
    case .framework:
      return (
        base: [
          "CODE_SIGN_STYLE": "Manual",
          "DEVELOPMENT_TEAM": "WN2B884S76"
        ],
        configs: [
          .debug(name: "Debug", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "\(baseBundleId).dev.ADA.app",
            "PROVISIONING_PROFILE_SPECIFIER": "match Development \(baseBundleId).dev.ADA.app",
            "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)"
          ]),
          .release(name: "Release", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "\(baseBundleId).dev.ADA.\(name)"
          ])
        ]
      )
    case .appExtension:
      return (
        base: [
          "DEVELOPMENT_TEAM": "WN2B884S76",
          "CODE_SIGN_STYLE": "Manual",
          "TARGETED_DEVICE_FAMILY": "1,2"
        ],
        configs: [
          .debug(name: "Debug", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "\(baseBundleId).dev.app.\(bundleIdName)",
            "CODE_SIGN_IDENTITY": "Apple Development: Yunhong Kim (Q7CMJ86WZQ)",
            "PROVISIONING_PROFILE_SPECIFIER": "\(baseBundleId).dev.app.\(bundleIdName) Development"
          ]),
          .release(name: "Release", settings: [
            "CODE_SIGN_IDENTITY": "Apple Distribution: Yunhong Kim (WN2B884S76)",
            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore \(baseBundleId).dev.ADA.app.\(bundleIdName == "shareExtension" ? "actionExtension" : "safariExtension")",
            "PRODUCT_BUNDLE_IDENTIFIER": "\(baseBundleId).dev.ADA.app.\(bundleIdName == "shareExtension" ? "actionExtension" : "safariExtension")"
          ])
        ]
      )
    case .app:
      print("탭탭 개발자들 파이팅🔥")
      return (
        base: [
          "CODE_SIGN_STYLE": "Manual",
          "DEVELOPMENT_TEAM": "WN2B884S76"
        ],
        configs: [
          .debug(name: "Debug", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "\(baseBundleId).dev.app",
            "PROVISIONING_PROFILE_SPECIFIER": "\(baseBundleId).dev.app Development",
            "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDev",
            "INFOPLIST_KEY_CFBundleDisplayName": "탭탭Dev",
          ]),
          .release(name: "Release", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "\(baseBundleId).dev.ADA.app",
            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore \(baseBundleId).dev.ADA.app",
            "CODE_SIGN_IDENTITY": "Apple Distribution: Yunhong Kim (WN2B884S76)",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon"
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
            "PRODUCT_BUNDLE_IDENTIFIER": "\(baseBundleId).dev.\(name.lowercased())"
          ]),
          .release(name: "Release", settings: [
            "PRODUCT_BUNDLE_IDENTIFIER": "\(baseBundleId).ADA.\(name.lowercased())"
          ])
        ]
      )
    }
  }
}
