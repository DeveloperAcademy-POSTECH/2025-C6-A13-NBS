//
//  OnboardingPageControl.swift
//  Nbs
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

public struct OnboardingPageControl {
  var numberOfPages: Int
  var currentPage: Int
  
  public init(numberOfPages: Int, currentPage: Int) {
    self.numberOfPages = numberOfPages
    self.currentPage = currentPage
  }
}

extension OnboardingPageControl: View {
  public var body: some View {
    HStack(spacing: 5) {
      ForEach(0..<numberOfPages, id: \.self) { pagingIndex in
        let isCurrentPage = currentPage == pagingIndex
        
        Capsule()
          .fill(isCurrentPage ? .bl3 : .n30)
      }
    }
    .animation(.linear, value: currentPage)
    .frame(height: 4)
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 20)
  }
}

#Preview {
  OnboardingPageControl(numberOfPages: 3, currentPage: 1)
}
