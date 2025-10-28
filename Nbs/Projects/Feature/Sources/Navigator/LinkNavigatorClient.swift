import LinkNavigator
import ComposableArchitecture
import Foundation

struct LinkNavigatorClient {
  var push: (Route, Codable?) -> Void
  var pop: () async -> Void
}

extension LinkNavigatorClient: DependencyKey {
  static let liveValue = Self(
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
  var linkNavigator: LinkNavigatorClient {
    get { self[LinkNavigatorClient.self] }
    set { self[LinkNavigatorClient.self] = newValue }
  }
}

extension LinkNavigatorClient {
  init(navigator: SingleLinkNavigator) {
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
