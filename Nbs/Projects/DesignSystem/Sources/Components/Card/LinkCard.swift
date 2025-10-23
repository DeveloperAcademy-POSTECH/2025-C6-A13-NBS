//
//  LinkCard.swift
//  DesignSystem
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

// MARK: - Properties
public struct LinkCard: View {
  let title: String
  let newsCompany: String
  let image: String
  let date: String
  
  public init(
    title: String,
    newsCompany: String,
    image: String,
    date: String
  ) {
    self.title = title
    self.newsCompany = newsCompany
    self.image = image
    self.date = date
  }
}

// MARK: - View
extension LinkCard {
  public var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        Text(title)
          .font(.B1_SB)
          .foregroundStyle(.text1)
          .multilineTextAlignment(.leading)
          .lineLimit(2)
          .padding(.bottom, 2)
        
        Text(newsCompany)
          .font(.B2_M)
          .foregroundStyle(.caption2)
        Spacer()
        Text(date)
          .font(.B2_M)
          .foregroundStyle(.caption2)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 10)
      .padding(.leading, 16)
      
      DesignSystemAsset.notImage.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 84, height: 112)
        .background(.gray)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(.vertical, 10)
        .padding(.leading, 12)
        .padding(.trailing, 10)
    }
    .frame(maxWidth: .infinity)
    .frame(maxHeight: 132)
    .background(.n0)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}

#Preview {
  LinkCard(title: "트럼프", newsCompany: "조선비즈", image: "mockImage", date: "2025년 10월 7일")
}
