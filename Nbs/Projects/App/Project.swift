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
  destinations: .iOS,
  product: .appExtension,
  bundleId: Project.bundleID + ".app.safariExtension",
  deploymentTargets: .iOS("17.0"),
  infoPlist: .file(path: "SafariExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.SafariExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.SafariExtension.resourcesPath)],
  entitlements: .file(path: "SafariExtension.entitlements"),
  dependencies: [
    .domain()
  ],
  settings: .settings(
    base: [
      "DEVELOPMENT_TEAM": "WN2B884S76",
      "CODE_SIGN_STYLE": "Manual"
    ],
    configurations: [
      .debug(name: "Debug", settings: [
        "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.dev.app.safariExtension",
        "CODE_SIGN_IDENTITY": "Apple Development: Yunhong Kim (Q7CMJ86WZQ)",
        "PROVISIONING_PROFILE_SPECIFIER": "com.Nbs.dev.app.safariExtension Development"
      ]),
      .release(name: "Release", settings: [
        "CODE_SIGN_IDENTITY": "Apple Distribution: Yunhong Kim (WN2B884S76)",
        "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.Nbs.dev.ADA.app.safariExtension"
      ])
    ]
  )
)

let shareExtensionTarget = Target.target(
  name: TargetName.ShareExtension.rawValue,
  destinations: .iOS,
  product: .appExtension,
  bundleId: Project.bundleID + ".app.shareExtension",
  deploymentTargets: .iOS("17.0"),
  infoPlist: .file(path: "ShareExtension/info.plist"),
  sources: [SourceFileGlob(stringLiteral: TargetName.ShareExtension.sourcesPath)],
  resources: [ResourceFileElement(stringLiteral: TargetName.ShareExtension.resourcesPath)],
  entitlements: .file(path: "ShareExtension.entitlements"),
  dependencies: [
    .sdk(name: "UniformTypeIdentifiers", type: .framework),
    .designSystem(),
    .domain()
  ],
  settings: .settings(
    base: [
      "DEVELOPMENT_TEAM": "WN2B884S76",
      "CODE_SIGN_STYLE": "Manual",
      "TARGETED_DEVICE_FAMILY": "1,2"
    ],
    configurations: [
      .debug(name: "Debug", settings: [
        "PRODUCT_BUNDLE_IDENTIFIER": "com.Nbs.dev.app.shareExtension",
        "CODE_SIGN_IDENTITY": "Apple Development: Yunhong Kim (Q7CMJ86WZQ)",
        "PROVISIONING_PROFILE_SPECIFIER": "com.Nbs.dev.app.shareExtension Development"
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
    shareExtensionTarget
  ]
)
