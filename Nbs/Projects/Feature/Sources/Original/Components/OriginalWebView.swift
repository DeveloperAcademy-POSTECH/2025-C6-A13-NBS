//
//  OriginalWebView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI
import WebKit

struct OriginalWebView: UIViewRepresentable {
  let url: URL
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    uiView.load(request)
  }
}
