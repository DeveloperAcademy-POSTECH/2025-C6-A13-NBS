//
//  SearchResultView.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import SwiftUI

import DesignSystem

// MARK: - Properties
struct SearchResultView: View {
}

// MARK: - View
extension SearchResultView {
  var body: some View {
    VStack(alignment: .leading) {
      //Text("'\()' 관련 결과 \()")
      HStack {
        Text("'고기' 관련 결과 13개")
          .font(.B2_M)
          .foregroundStyle(.caption2)

        Spacer()
        
        Button {
          
        } label: {
          HStack(spacing: 6) {
            Text("시사 스터디")
              .padding(.leading, 18)
              .foregroundStyle(.caption1)
              .font(.B2_M)
            Image(icon: Icon.smallChevronDown)
              .frame(width: 20, height: 20)
              .padding(.trailing, 12)
          }
          .padding(.vertical, 6)
          .clipShape(.capsule)
          .overlay {
            RoundedRectangle(cornerRadius: 1000)
              .stroke(.divider1, lineWidth: 1)
          }
        }
      }
      
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack {
          ForEach(1..<13) { _ in
            LinkCard(title: "트럼프 11월 1일부터 중대형 트럭에 25% 관세 부과", newsCompany: "조선 비즈", image: "plus", date: "2025년 10월 7일")
          }
        }
      }
    }
    .background(Color.clear)
  }
}

#Preview {
  SearchResultView()
}
