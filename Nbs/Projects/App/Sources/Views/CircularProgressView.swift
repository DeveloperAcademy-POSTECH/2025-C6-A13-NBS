import SwiftUI

import DesignSystem

struct CircularProgressView: View {
  var currentPage: Int
  var numberOfPages: Int
  
  var body: some View {
    HStack {
      ForEach(0..<numberOfPages) { index in
        Circle()
          .fill(
            index == currentPage ? DesignSystemAsset.bl6.swiftUIColor : DesignSystemAsset.n40.swiftUIColor
          )
          .frame(width: 10, height: 10)
      }
    }
  }
}

struct CircularProgressView_Previews: PreviewProvider {
  static var previews: some View {
    CircularProgressView(currentPage: 0, numberOfPages: 3)
  }
}
