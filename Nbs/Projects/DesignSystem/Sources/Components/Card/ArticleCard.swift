//
//  ArticleCard.swift
//  DesignSystem
//
//  Created by 홍 on 10/15/25.
//

import SwiftUI

/// 기사/링크 리스트 공용 카드 뷰
///
/// - title, categoryName, imageURL, dateString 등은 Feature 계층에서 변환하여 전달
public struct ArticleCard: View {
  
  // MARK: - Properties
  private let title: String
  private let categoryName: String?
  private let imageURL: String?
  private let dateString: String
  @Binding private var isSelected: Bool
  private let editMode: EditMode
  
  // MARK: - Init
  public init(
    title: String,
    categoryName: String?,
    imageURL: String?,
    dateString: String,
    isSelected: Binding<Bool> = .constant(false),
    editMode: EditMode = .inactive
  ) {
    self.title = title
    self.categoryName = categoryName
    self.imageURL = imageURL
    self.dateString = dateString
    self._isSelected = isSelected
    self.editMode = editMode
  }
}

// MARK: - View
extension ArticleCard {
  public var body: some View {
    HStack(spacing: 0) {
      textContents
      Spacer()
      rightContents
    }
    .frame(maxWidth: .infinity)
    .frame(maxHeight: 132)
    .background(backgroundColor)
    .overlay(borderOverlay)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .animation(.easeInOut(duration: 0.2), value: editMode)
    .animation(.easeInOut(duration: 0.15), value: isSelected)
  }
  
  /// 텍스트 영역
  private var textContents: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.B1_SB)
        .foregroundStyle(.text1)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      Text(categoryName ?? "카테고리 없음")
        .font(.B2_M)
        .foregroundStyle(.caption2)
      
      Spacer()
      
      Text(dateString)
        .font(.B2_M)
        .foregroundStyle(.caption2)
    }
    .padding(.vertical, 10)
    .padding(.leading, 16)
  }
  
  /// 이미지 + 체크박스
  private var rightContents: some View {
    ZStack(alignment: .topTrailing) {
      articleImage
        .padding(.vertical, 10)
        .padding(.trailing, 10)
      
      if editMode == .active {
        CheckboxButton(isOn: $isSelected)
          .offset(x: -16, y: 16)
      }
    }
  }
}

// MARK: - Subviews
private extension ArticleCard {
  var articleImage: some View {
    AsyncImage(url: URL(string: imageURL ?? "")) { phase in
      switch phase {
      case .empty:
        ProgressView()
          .frame(width: 84, height: 112)
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 84, height: 112)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 6))
      case .failure:
        DesignSystemAsset.notImage.swiftUIImage
          .resizable()
          .scaledToFit()
          .frame(width: 84, height: 112)
          .foregroundColor(.gray)
      @unknown default:
        EmptyView()
      }
    }
  }
  
  var backgroundColor: Color {
    if editMode == .active && isSelected {
      return .bl6.opacity(0.15)
    } else {
      return .n0
    }
  }
  
  var borderOverlay: some View {
    RoundedRectangle(cornerRadius: 12)
      .stroke(editMode == .active && isSelected ? .bl6 : .clear, lineWidth: editMode == .active ? 1.5 : 0)
  }
}

// MARK: - Preview
#Preview {
  VStack {
    ArticleCard(
      title: "트럼프 “11월 1일부터 중·대형 트럭에 25% 관세 부과”",
      categoryName: "정치",
      imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb",
      dateString: "2025년 10월 7일"
    )
    ArticleCard(
       title: "AI가 뉴스 생태계를 바꾸다",
       categoryName: "기술",
       imageURL: "https://images.unsplash.com/photo-1542744094-24638eff58bb",
       dateString: "2025년 10월 19일",
       isSelected: .constant(true),
       editMode: .active
     )
  }
}
