//
//  AlertClearBackgroundView.swift
//  DesignSystem
//
//  Created by 여성일 on 11/10/25.
//

import UIKit
import SwiftUI

public struct AlertClearBackgroundView: UIViewRepresentable {
  public init() { }
  public func makeUIView(context: Context) -> some UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) {}
}
