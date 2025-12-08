import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.TapTapMac.rawValue,
  targets: [
    Target.target(
      name: Module.TapTapMac.rawValue,
      product: .staticFramework,
      sources: .sources,
      resources: .default,
      dependencies: [
        .domain(),
        .designSystem()
      ]
    )
  ]
)
