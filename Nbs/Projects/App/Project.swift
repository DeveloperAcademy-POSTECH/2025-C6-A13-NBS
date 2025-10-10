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
      "CODE_SIGN_STYLE": "Automatic",
      "DEVELOPMENT_TEAM": "WN2B884S76"
    ],
    configurations: [
      .debug(name: "Debug", settings: [
        "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.dev.ADA.app.safariExtension"
      ]),
      .release(name: "Release", settings: [
        "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.ADA.app.safariExtension"
      ])
    ]
  )
)

let project = Project.project(
  name: Project.appName,
  targets: [
    appTarget,
    safariTarget
  ]
)
