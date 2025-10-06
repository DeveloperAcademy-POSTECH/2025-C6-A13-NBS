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

let safariTarget = Target.target (
  name: TargetName.SafariExtension.rawValue,
  destinations: .iOS,
  product: .appExtension,
  bundleId: Project.bundleID + ".app".lowercased() + ".safariExtension",
  infoPlist: .file(path: "SafariExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.SafariExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.SafariExtension.resourcesPath)]
)

let project = Project.project(
  name: Project.appName,
  targets: [
    appTarget,
    safariTarget
  ]
)
