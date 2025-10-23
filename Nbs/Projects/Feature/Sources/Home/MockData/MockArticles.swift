//
//  MockArticles.swift
//  Feature
//
//  Created by 홍 on 10/16/25.
//

import Foundation
import DesignSystem

struct MockArticle: ArticleDisplayable, Identifiable, Equatable {
  var id: UUID = UUID()
  var url: String? = "https://example.com"
  var imageURL: String? = "https://example.com/image.jpg"
  var title: String = "목업 기사 제목"
  var createAt: Date = .now
  var newsCompany: String = "조선일보"
  
  var dateToString: String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy년 M월 d일"
//    return formatter.string(from: createAt)
    return dateToString
  }
  
  static let mockArticles: [MockArticle] = [
    MockArticle(
      url: "https://biz.chosun.com/article1",
      imageURL: "https://picsum.photos/200/200?random=1",
      title: "트럼프 “11월 1일부터 중·대형 트럭에 25% 관세 부과“",
      createAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
      newsCompany: "조선일보"
    ),
    MockArticle(
      url: "https://biz.donga.com/article2",
      imageURL: "https://picsum.photos/200/200?random=2",
      title: "AI 기술 발전과 산업 영향",
      createAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)!,
      newsCompany: "동아일보"
    ),
    MockArticle(
      url: "https://www.hani.co.kr/article3",
      imageURL: "https://picsum.photos/200/200?random=3",
      title: "서울 집값, 5년 만에 최고",
      createAt: Calendar.current.date(byAdding: .day, value: -3, to: .now)!,
      newsCompany: "한겨레"
    ),
    MockArticle(
      url: "https://www.hankyung.com/article4",
      imageURL: "https://picsum.photos/200/200?random=4",
      title: "전기차 보조금 정책 발표",
      createAt: Calendar.current.date(byAdding: .day, value: -4, to: .now)!,
      newsCompany: "한국경제"
    ),
    MockArticle(
      url: "https://biz.chosun.com/article5",
      imageURL: "https://picsum.photos/200/200?random=5",
      title: "우주 관광 시대 개막",
      createAt: Calendar.current.date(byAdding: .day, value: -5, to: .now)!,
      newsCompany: "조선비즈"
    ),
    MockArticle(
      url: "https://www.mk.co.kr/article6",
      imageURL: "https://picsum.photos/200/200?random=6",
      title: "글로벌 경제 전망",
      createAt: Calendar.current.date(byAdding: .day, value: -6, to: .now)!,
      newsCompany: "매일경제"
    ),
    MockArticle(
      url: "https://www.khan.co.kr/article7",
      imageURL: "https://picsum.photos/200/200?random=7",
      title: "환경 보호와 정책 변화",
      createAt: Calendar.current.date(byAdding: .day, value: -7, to: .now)!,
      newsCompany: "경향신문"
    ),
    MockArticle(
      url: "https://www.etnews.com/article8",
      imageURL: "https://picsum.photos/200/200?random=8",
      title: "IT 기업 채용 경쟁 심화",
      createAt: Calendar.current.date(byAdding: .day, value: -8, to: .now)!,
      newsCompany: "전자신문"
    ),
    MockArticle(
      url: "https://www.mt.co.kr/article9",
      imageURL: "https://picsum.photos/200/200?random=9",
      title: "신재생 에너지 투자 증가",
      createAt: Calendar.current.date(byAdding: .day, value: -9, to: .now)!,
      newsCompany: "머니투데이"
    ),
    MockArticle(
      url: "https://sportsseoul.com/article10",
      imageURL: "https://picsum.photos/200/200?random=10",
      title: "스포츠 스타 광고 효과 분석",
      createAt: Calendar.current.date(byAdding: .day, value: -10, to: .now)!,
      newsCompany: "스포츠서울"
    )
  ]
}
