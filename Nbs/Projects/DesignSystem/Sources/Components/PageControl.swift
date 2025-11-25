//
//  PageControl.swift
//  DesignSystem
//
//  Created by 홍 on 11/25/25.
//

import SwiftUI

struct PageControl: View {
  
  var numberOfPages: Int
  @Binding var currentPage: Int
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<numberOfPages, id: \.self) { pagingIndex in
        
        let isCurrentPage = currentPage == pagingIndex
        let height = 8.0
        let width = isCurrentPage ? height * 2 : height
        
        Capsule()
          .fill(
            isCurrentPage ? .bl6 : .bl3.opacity(0.7)
          )
          .frame(width: width, height: height)
      }
    }
    .animation(.linear, value: currentPage)
  }
}

#Preview {
  PageControl(numberOfPages: 5, currentPage: .constant(3))
}
