//
//  ShowSplash.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import SwiftUI

struct SplashView: View {
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      VStack {
        Text("NBS")
          .font(.largeTitle.bold())
          .foregroundStyle(.white)
      }
    }
  }
}
