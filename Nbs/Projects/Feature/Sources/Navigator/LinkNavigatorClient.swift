import LinkNavigator
import ComposableArchitecture
import Foundation

public struct LinkNavigatorClient {
  public var push: (Route, Codable?) -> Void
  public var pop: () async -> Void
}

extension LinkNavigatorClient: DependencyKey {
  public static let liveValue = Self(
    push: { _, _ in
      #if DEBUG
      print("LinkNavigatorClient.push called, but not implemented.")
      #endif
    },
    pop: {
      #if DEBUG
      print("LinkNavigatorClient.pop called, but not implemented.")
      #endif
    }
  )
}

extension DependencyValues {
  public var linkNavigator: LinkNavigatorClient {
    get { self[LinkNavigatorClient.self] }
    set { self[LinkNavigatorClient.self] = newValue }
  }
}

extension LinkNavigatorClient {
  public init(navigator: SingleLinkNavigator) {
    self.push = { path, items in
      DispatchQueue.main.async {
        navigator.next(linkItem: .init(path: path.rawValue, items: items), isAnimated: true)
      }
    }
    self.pop = {
      await MainActor.run {
        navigator.back(isAnimated: true)
      }
    }
  }
}
