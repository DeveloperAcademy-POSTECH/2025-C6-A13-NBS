//
//  ActionBottomSheet.swift
//  DesignSystem
//
//  Created by 이안 on 10/15/25.
//
  
import SwiftUI

public struct ActionBottomSheet<Content: View>: View {
  private let content: Content
  private let onDismiss: () -> Void
  @State private var offset: CGFloat = UIScreen.main.bounds.height
  
  public init(
    onDismiss: @escaping () -> Void,
    @ViewBuilder content: () -> Content
  ) {
    self.onDismiss = onDismiss
    self.content = content()
  }

  public var body: some View {
    ZStack {
      Color.black.opacity(0.3)
        .ignoresSafeArea()
        .onTapGesture { dismiss() }

      VStack(spacing: 0) {
        Spacer()
        content
          .frame(maxWidth: .infinity)
          .background(Color.background)
          .cornerRadius(16)
          .offset(y: offset)
      }
      .ignoresSafeArea(edges: .bottom)
    }
    .onAppear {
      withAnimation(.easeOut(duration: 0.25)) { offset = 0 }
    }
  }

  private func dismiss() {
    withAnimation(.easeIn(duration: 0.25)) {
      offset = UIScreen.main.bounds.height
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
      onDismiss()
    }
  }
}
