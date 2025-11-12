//
//  Clipboard.swift
//  Feature
//
//  Created by 홍 on 11/11/25.
//

import SwiftUI
import ComposableArchitecture

extension DependencyValues {
  var clipboard: ClipboardClient {
    get { self[ClipboardClient.self] }
    set { self[ClipboardClient.self] = newValue }
  }
}

struct ClipboardClient {
  var getString: () -> String?
}

extension ClipboardClient: DependencyKey {
  static let liveValue = Self(
    getString: { UIPasteboard.general.string }
  )
}