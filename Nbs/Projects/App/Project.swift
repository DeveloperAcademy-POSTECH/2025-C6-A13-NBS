import ProjectDescription
import ProjectDescriptionHelpers

enum Scheme: String {
  case DEV
  case RELEASE
}

let appTarget = Target.target(
  name: Project.appName,
  product: .app,
  bundleId: "com.Nbs.dev.app",
  infoPlist: .extendingDefault(
    with: [
      "UILaunchScreen": [
        "UIColorName": "",
        "UIImageName": "",
      ],
      "CFBundleDevelopmentRegion": "ko",
      "CFBundleLocalizations": ["ko"],
      "CFBundleVersion": "1",
      "CFBundleDisplayName": "탭탭",
      "CFBundleShortVersionString": "1.0.4",

      "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
      ],
      "UIBackgroundModes": [
        "audio"
      ],
      "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait"
      ],
      "CFBundleURLTypes": [
        [
          "CFBundleURLSchemes": ["nbs"]
        ]
      ]
    ]
  ),
  sources: .sources,
  resources: .default,
  entitlements: .file(path: "App.entitlements"),
  dependencies: [
    .safariEx(),
    .actionEx(),
    .feature(),
  ]
)

let safariTarget = Target.target(
  name: TargetName.SafariExtension.rawValue,
  product: .appExtension,
  bundleId: Project.bundleID + ".app.safariExtension",
  infoPlist: .file(path: "SafariExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.SafariExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.SafariExtension.resourcesPath)],
  entitlements: .file(path: "SafariExtension.entitlements"),
  dependencies: [
    .domain()
  ]
)

let shareExtensionTarget = Target.target(
  name: TargetName.ShareExtension.rawValue,
  product: .appExtension,
  bundleId: Project.bundleID + ".app.shareExtension",
  infoPlist: .file(path: "ShareExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.ShareExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.ShareExtension.resourcesPath)],
  entitlements: .file(path: "ShareExtension.entitlements"),
  dependencies: [
    .sdk(name: "UniformTypeIdentifiers", type: .framework),
    .designSystem(),
    .domain()
  ]
)

let project = Project.project(
  name: Project.appName,
  targets: [
    appTarget,
    safariTarget,
    shareExtensionTarget
  ]
)
