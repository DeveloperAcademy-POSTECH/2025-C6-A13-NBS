//
//  OnboardingHighlight.swift
//  Nbs
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import Lottie

struct HighlightRectPreferenceKey: PreferenceKey {
  static var defaultValue: CGRect = .zero
  
  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

struct TooltipHeightPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

struct OnboardingHighlightView {
  let store: StoreOf<OnboardingHighlightFeature>
  @State private var showDimmingWithAnimation: Bool = false
  @State private var showTooltip: Bool = true
  @State private var showHighlightTip: Bool = false
  @State private var highlightColor: Color = .highlightWhat
  @State private var highlightRect: CGRect = .zero
  @State private var tooltipText: String = "하이라이트 치는 방법을 배워볼게요"
  @State private var isTextHighlighted: Bool = false
  @State private var currentPage: Int = 0
  @State private var navigationTitle: String = "문장 하이라이트"
  @State private var didChangeColor: Bool = false
  @State private var showMemo: Bool = false
  @State private var showMemoChip: Bool = false
  @State private var tooltipHeight: CGFloat = .zero
  @State private var highlightTipHeight: CGFloat = .zero
}

extension OnboardingHighlightView: View {
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        TopAppBarDefaultRightIconx(title: navigationTitle) {
          store.send(.backButtonTapped)
        }
        OnboardingPageControl(numberOfPages: 2, currentPage: currentPage)
        
        ZStack(alignment: .top) {
          VStack(spacing: 0) {
            articleScriptHeader
              .padding(.top, 30)
            VStack(spacing: 2) {
              Group {
                Text("나의 하이라이트가 쌓일수록, 뉴스는 단순한 읽을거리가")
                Text("아니라 나만의 데이터가 됩니다.")
              }
              .font(.B1_M_HL)
              .foregroundStyle(.text1)
              .background(isTextHighlighted ? highlightColor : Color.clear)
              .frame(maxWidth: .infinity, alignment: .leading)
              
              VStack(spacing: 0) {
                Text("하이라이트 문장을 읽고 중요한 것들에 대한 메모")
                  .font(.B1_M_HL)
                  .foregroundStyle(.text1)
                  .opacity(showMemo ? 1 : 0)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .frame(height: showMemo ? nil : 0)
                  .padding(.horizontal, showMemo ? 16 : 0)
                  .padding(.top, showMemo ? 16 : 0)
                Text("를 동시에 남겨요.")
                  .font(.B1_M_HL)
                  .foregroundStyle(.text1)
                  .opacity(showMemo ? 1 : 0)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .frame(height: showMemo ? nil : 0)
                  .padding(.horizontal)
                  .padding(.bottom, showMemo ? 16 : 0)
                OnboardingToolTipBox(text: "원하는 메모를 입력하면")
                  .opacity(showMemo ? 1 : 0)
                  .frame(height: showMemo ? nil : 0)
              }
              .background(showMemo ? .n30 : .clear)
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .offset(y: 12)
            }
            .padding(.horizontal, 20)
            .background(
              GeometryReader { geometry in
                Color.clear
                  .preference(key: HighlightRectPreferenceKey.self, value: geometry.frame(in: .named("dimmableVStack")))
              }
            )
            .onTapGesture(count: 1) {
              if isTextHighlighted && !store.showMemo {
                showHighlightTip = true
              }
            }
            .onTapGesture(count: 2) {
              if store.showDimming {
                store.send(.taptap)
                isTextHighlighted = true
                tooltipText = "해당 문장이 하이라이트 돼요"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  showTooltip = false
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tooltipText = "하이라이트 된 문장을 ‘한 번’ 탭하여 \n툴팁을 꺼내요"
                    withAnimation(.easeIn(duration: 0.1)) {
                      showTooltip = true
                    }
                  }
                }
              }
            }
            
            if showMemoChip {
              MemoChipView(selectedColor: $highlightColor)
                .offset(y: 20)
            }
            
            articleScript3
              .padding(.top, 24)
            articleScript2
              .padding(.top, 40)
            articleScript
              .padding(.top, 40)
            Spacer()
            if !showMemoChip {
              DesignSystemAsset.toolbarBottom.swiftUIImage
                .resizable()
                .scaledToFit()
                .padding(.bottom, -20)
            }
          }
          
          if showDimmingWithAnimation {
            Color.bgDimOnboarding
              .mask(
                Rectangle()
                  .overlay(
                    Rectangle()
                      .frame(width: highlightRect.width, height: highlightRect.height)
                      .position(x: highlightRect.midX, y: highlightRect.midY)
                      .blendMode(.destinationOut)
                  )
              )
              .ignoresSafeArea()
              .allowsHitTesting(false)
          }
          
          if showTooltip && highlightRect != .zero && !showHighlightTip {
            OnboardingToolTipBox(text: tooltipText)
              .background(GeometryReader {
                Color.clear.preference(key: TooltipHeightPreferenceKey.self, value: $0.size.height)
              })
              .onPreferenceChange(TooltipHeightPreferenceKey.self) {
                tooltipHeight = $0
              }
              .position(x: highlightRect.midX, y: highlightRect.maxY + 8 + tooltipHeight / 2)
              .transition(.opacity)
          }
          
          if showHighlightTip && highlightRect != .zero {
            Group {
              if !didChangeColor {
                VStack {
                  OnboardingToolTipBoxBottom(text: "원하는 색상을 탭하여\n하이라이트 색상을 변경해요")
                  OnboardingHighlightTip(selectedColor: $highlightColor, onMemoTapped: {
                    showMemo = true
                    showHighlightTip = false
                    showTooltip = false
                    store.send(.memoButtonTapped)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                      showMemo = false
                      showMemoChip = true
                    }
                  })
                }
              } else {
                VStack {
                  OnboardingToolTipBoxBottomTrailing(text: "메모를 탭 해 메모를 남겨보아요")
                    .offset(y: 6)
                  OnboardingHighlightTip(selectedColor: $highlightColor, onMemoTapped: {
                    showMemo = true
                    showHighlightTip = false
                    showTooltip = false
                    store.send(.memoButtonTapped)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                      showMemo = false
                      showMemoChip = true
                    }
                  })
                  .offset(y: 18)
                }
              }
            }
            //            .background(GeometryReader {
            //                Color.clear.preference(key: TooltipHeightPreferenceKey.self, value: $0.size.height)
            //            })
            //            .onPreferenceChange(TooltipHeightPreferenceKey.self) {
            //                highlightTipHeight = $0
            //            }
            .position(x: highlightRect.midX, y: highlightRect.minY - 78)
            .transition(.opacity)
          }
        }
        .coordinateSpace(name: "dimmableVStack")
        .onPreferenceChange(HighlightRectPreferenceKey.self) { rect in
          highlightRect = rect
        }
        .onChange(of: highlightColor) {
          currentPage = 1
          navigationTitle = "메모 입력하기"
          didChangeColor = true
        }
      }
      if showMemoChip {
        VStack {
          Spacer()
          MainButton("완료") {
            store.send(.finishButtonTapped)
          }
          .padding(.bottom, 8)
        }
      }
    }
    .background(Color.background)
    .toolbar(.hidden)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        store.send(.onAppear)
        tooltipText = "하이라이트 치고 싶은 부분을 \n’두 번’ 탭해요"
      }
    }
    .onChange(of: store.showDimming) { _, showDimming in
      withAnimation(.easeInOut(duration: 0.3)) {
        self.showDimmingWithAnimation = showDimming
      }
    }
  }
}
