import ProjectDescription
import ProjectDescriptionHelpers

enum Scheme: String {
  case DEV
  case RELEASE
}

let appTarget = Target.target(
  name: Project.appName,
  product: .app,
  bundleId: "com.Nbs.dev.ADA.app",
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
  entitlements: .file(path: "App.entitlements"),
  dependencies: [
    .safariEx(),
    .actionEx(),
    .feature(),
  ],
  settings: .settings(
    base: [
      "DEVELOPMENT_TEAM": "WN2B884S76",
      "CODE_SIGN_STYLE": "Automatic"
    ],
    configurations: [
      .debug(name: "Debug", settings: [
        "CODE_SIGN_IDENTITY": "Apple Development: Yunhong Kim (Q7CMJ86WZQ)",
        "PROVISIONING_PROFILE_SPECIFIER": "match Development com.Nbs.dev.ADA.app"
      ]),
      .release(name: "Release", settings: [
        "CODE_SIGN_IDENTITY": "Apple Distribution: Yunhong Kim (WN2B884S76)",
        "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.Nbs.ADA.app"
      ])
    ]
  )
)

let safariTarget = Target.target(
  name: TargetName.SafariExtension.rawValue,
  destinations: .iOS,
  product: .appExtension,
  bundleId: Project.bundleID + ".app.safariExtension",
  deploymentTargets: .iOS("17.0"),
  infoPlist: .file(path: "SafariExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.SafariExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.SafariExtension.resourcesPath)],
  entitlements: .file(path: "SafariExtension.entitlements"),
  settings: .settings(
    base: [
      "DEVELOPMENT_TEAM": "WN2B884S76",
      "CODE_SIGN_STYLE": "Manual"
    ],
    configurations: [
      .debug(name: "Debug", settings: [
        "CODE_SIGN_IDENTITY": "Apple Development: Yunhong Kim (Q7CMJ86WZQ)",
        "PROVISIONING_PROFILE_SPECIFIER": "match Development com.Nbs.dev.ADA.app.safariExtension"
      ]),
      .release(name: "Release", settings: [
        "CODE_SIGN_IDENTITY": "Apple Distribution: Yunhong Kim (WN2B884S76)",
        "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.Nbs.dev.ADA.app.safariExtension"
      ])
    ]
  )
)

let actionExtensionTarget = Target.target(
  name: TargetName.ActionExtension.rawValue,
  destinations: .iOS,
  product: .appExtension,
  bundleId: Project.bundleID + ".app.actionExtension",
  deploymentTargets: .iOS("17.0"),
  infoPlist: .file(path: "ActionExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.ActionExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.ActionExtension.resourcesPath)],
  entitlements: .file(path: "ActionExtension.entitlements"),
  dependencies: [
    .sdk(name: "UniformTypeIdentifiers", type: .framework),
    .designSystem()
  ],
  settings: .settings(
    base: [
      "DEVELOPMENT_TEAM": "WN2B884S76",
      "CODE_SIGN_STYLE": "Manual",
      "TARGETED_DEVICE_FAMILY": "1,2"
    ],
    configurations: [
      .debug(name: "Debug", settings: [
        "CODE_SIGN_IDENTITY": "Apple Development: Yunhong Kim (Q7CMJ86WZQ)",
        "PROVISIONING_PROFILE_SPECIFIER": "match Development com.Nbs.dev.ADA.app.actionExtension"
      ]),
      .release(name: "Release", settings: [
        "CODE_SIGN_IDENTITY": "Apple Distribution: Yunhong Kim (WN2B884S76)",
        "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.Nbs.dev.ADA.app.actionExtension"
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
