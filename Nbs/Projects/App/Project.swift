import ProjectDescription
import ProjectDescriptionHelpers

enum Scheme: String {
  case DEV
  case REALSE
}

let appTarget = Target.target(
  name: Project.appName,
  product: .app,
  bundleId: Project.bundleID + ".app".lowercased(),
  infoPlist: .extendingDefault(
    with: [
      "UILaunchScreen": [
        "UIColorName": "",
        "UIImageName": "",
      ],
    ]
  ),
  sources: .sources,
  resources: .default,
  dependencies: [
    .safariEx(),
    .actionEx(),
    .feature(),
  ]
)

let safariTarget = Target.target(
  name: TargetName.SafariExtension.rawValue,
  destinations: .iOS,
  product: .appExtension,
  bundleId: Project.bundleID + ".app.safariExtension",
  infoPlist: .file(path: "SafariExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.SafariExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.SafariExtension.resourcesPath)],
  settings: .settings(
    base: [
      "CODE_SIGN_STYLE": "Manual",
      "DEVELOPMENT_TEAM": "WN2B884S76"
    ],
    configurations: [
      .debug(name: "Debug", settings: [
        "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.dev.ADA.app.safariExtension",
        "PROVISIONING_PROFILE_SPECIFIER": "match Development com.Nbs.dev.ADA.*"
      ]),
      .release(name: "Release", settings: [
        "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.ADA.app.safariExtension",
        "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.Nbs.ADA.*"
      ])
    ]
  )
)

let actionExtensionTarget = Target.target(
  name: TargetName.ActionExtension.rawValue,
  destinations: .iOS,
  product: .appExtension,
  bundleId: Project.bundleID + ".app.actionExtension",
  infoPlist: .file(path: "ActionExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.ActionExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.ActionExtension.resourcesPath)],
  dependencies: [
    .sdk(name: "UniformTypeIdentifiers", type: .framework)
  ],
  settings: .settings(
    base: [
      "CODE_SIGN_STYLE": "Automatic", //Manual
      "DEVELOPMENT_TEAM": "WN2B884S76",
      "TARGETED_DEVICE_FAMILY": "1,2"
    ],
    configurations: [
      .debug(name: "Debug", settings: [
        "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.dev.ADA.app.actionExtension"
      ]),
      .release(name: "Release", settings: [
        "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.ADA.app.actionExtension"
      ])
    ]
  )
)

let project = Project.project(
  name: Project.appName,
  targets: [
    appTarget,
    safariTarget,
    actionExtensionTarget
  ]
)
