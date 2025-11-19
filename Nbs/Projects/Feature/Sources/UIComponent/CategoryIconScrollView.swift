import SwiftUI

import ComposableArchitecture
import DesignSystem
import Domain

struct CategoryIconScrollView {
  @Binding var selectedIcon: CategoryIcon?
  
  let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]
}

extension CategoryIconScrollView: View {
  var body: some View {
    VStack(spacing: 0) {
      Text("카테고리 아이콘")
        .font(.B2_SB)
        .foregroundStyle(.caption1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
        .padding(.top, 24)
        .padding(.bottom, 8)
      
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(1..<16, id: \.self) { index in
            let isSelected = selectedIcon?.number == index
            Button {
              selectedIcon = .init(number: index)
            } label: {
              RoundedRectangle(cornerRadius: 12)
                .fill(
                  isSelected
                  ? DesignSystemAsset.bl1.swiftUIColor
                  : DesignSystemAsset.n0.swiftUIColor
                )
                .overlay(
                  RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                      isSelected
                      ? DesignSystemAsset.bl6.swiftUIColor
                      : Color.clear,
                      lineWidth: 1.25
                    )
                )
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                  DesignSystemAsset.primaryCategoryIcon(number: index)
                    .resizable()
                    .frame(width: 56, height: 56)
                )
            }
            .shadow(color: .bgShadow3, radius: 4, x: 0, y: 0)
            .buttonStyle(.plain)
          }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
      }
      .scrollIndicators(.hidden)
    }
  }
}
