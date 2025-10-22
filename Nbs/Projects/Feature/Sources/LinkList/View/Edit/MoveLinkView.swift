//
//  MoveLinkView.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem

struct MoveLinkView: View {
  @Bindable var store: StoreOf<MoveLinkFeature>
}

extension MoveLinkView {
  var body: some View {
    ZStack {
      Color.background
        .ignoresSafeArea()
      VStack(spacing: 0) {
        topContents
        middleContents
        bottomContents
      }
    }
  }
  
  /// 링크 개수 + 선택 
  private var topContents: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("\(store.selectedLinks.count)개의 링크가 선택됐어요")
        .font(.H4_SB)
        .foregroundStyle(.text1)
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
      
      HStack(spacing: 4) {
        CheckboxButton(
          isOn: .init(
            get: { store.isSelectAll },
            set: { _ in store.send(.toggleSelectAll) }
          )
        ) {
          store.send(.toggleSelectAll)
        }
        
        Text("모두 선택")
          .font(.B2_SB)
          .foregroundStyle(.caption1)
        
        Spacer()
        
        Text("전체 (\(store.allLinks.count)개)")
          .font(.B2_M)
          .foregroundStyle(.caption3)
      }
      .padding(EdgeInsets(top: 8, leading: 20, bottom: 12, trailing: 20))
    }
  }
  
  /// 아티클카드 스크롤 뷰
  private var middleContents: some View {
    ScrollView {
      LazyVStack(spacing: 12) {
        ForEach(store.allLinks) { link in
          let binding = Binding<Bool>(
            get: { store.selectedLinks.contains(link.id) },
            set: { _ in store.send(.toggleSelect(link)) }
          )
          
          ArticleCard(
            title: link.title,
            categoryName: link.category?.categoryName,
            imageURL: link.imageURL,
            dateString: link.createAt.formatted(DateFormatter.date),
            isSelected: binding,
            editMode: .active
          )
          .id(link.id)
        }
      }
      .padding(.horizontal, 20)
    }
  }
  
  /// 취소 + 이동하기 버튼 모음
  private var bottomContents: some View {
    HStack(spacing: 12) {
      MainButton("취소", style: .soft) {
        store.send(.cancelTapped)
      }
      
      MainButton("이동하기", style: .deep, isDisabled: store.selectedLinks.isEmpty
      ) {
        store.send(.confirmMoveTapped)
      }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 44)
  }
}


#Preview {
  MoveLinkView(
    store: Store(
      initialState: MoveLinkFeature.State(
        allLinks: [
          .mock(
            title: "AI가 세상을 바꾸는 방법",
            category: "기술",
            imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb"
          ),
          .mock(
            title: "정치 변화의 흐름과 미래",
            category: "정치",
            imageURL: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e"
          ),
          .mock(
            title: "경제의 흐름과 트렌드",
            category: "경제",
            imageURL: "https://images.unsplash.com/photo-1543269865-cbf427effbad"
          )
        ],
        selectedLinks: [],
        isSelectAll: false
      )
    ) {
      MoveLinkFeature()
    }
  )
}

#if DEBUG
import Domain
import Foundation

extension LinkItem {
  static func mock(
    title: String,
    category: String? = nil,
    imageURL: String? = "https://images.unsplash.com/photo-1542744094-24638eff58bb"
  ) -> LinkItem {
    let item = LinkItem(
      urlString: "https://example.com",
      title: title,
      imageURL: imageURL,
      newsCompany: "연합뉴스"
    )
    if let categoryName = category {
      item.category = CategoryItem(
              categoryName: categoryName,
              icon: CategoryIcon(number: Int.random(in: 1...5))
            )
    }
    return item
  }
}
#endif
