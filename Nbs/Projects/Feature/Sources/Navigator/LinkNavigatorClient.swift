import LinkNavigator
import ComposableArchitecture
import Foundation

public struct LinkNavigatorClient {
  public var push: (Route, Codable?) -> Void
  public var pop: () async -> Void
  public var replace: ([Route], Codable?) -> Void
  public var remove: (Route) -> Void
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
    },
    replace: { _, _ in
      #if DEBUG
      print("not implemented")
      #endif
    },
    remove: { _ in
      
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
    self.replace = { paths, items in
      DispatchQueue.main.async {
        let pathList = paths.map(\.rawValue)
        guard !pathList.isEmpty else {
#if DEBUG
          print("replace 네비 명령어")
#endif
          return
        }
        if let path = pathList.first {
          navigator.replace(
            linkItem: .init(
              path: path,
              items: items
            ),
            isAnimated: true
          )
        }
      }
    }
    self.remove = { path in
        navigator.remove(pathList: [path.rawValue])
    }
  }
}
