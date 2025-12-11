import Foundation
import ComposableArchitecture
import SwiftUI

@main
struct MacApp: App {
  var body: some Scene {
    WindowGroup {
      MACContentView()
    }
  }
}
public struct TapTapMac {
  public init() {}
}

struct MACContentView: View {
  var body: some View {
    Text("Hello from macOS!")
    Image(systemName: "mac")
  }
}
