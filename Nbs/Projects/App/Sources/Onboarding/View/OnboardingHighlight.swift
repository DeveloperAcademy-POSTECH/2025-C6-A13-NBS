//
//  OnboardingHighlight.swift
//  Nbs
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct HighlightRectPreferenceKey: PreferenceKey {
  static var defaultValue: CGRect = .zero
  
  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

struct OnboardingHighlightView {
  let store: StoreOf<OnboardingHighlightFeature>
  @State private var showDimming: Bool = false
  @State private var showTooltip: Bool = true
  @State private var showHighlightTip: Bool = false
  @State private var highlightColor: Color = .chipPink
  @State private var highlightRect: CGRect = .zero
  @State private var tooltipText: String = "하이라이트 치는 방법을 배워볼게요"
  @State private var isTextHighlighted: Bool = false
  @State private var currentPage: Int = 0
  @State private var navigationTitle: String = "문장 하이라이트"
  @State private var didChangeColor: Bool = false
  @State private var showMemo: Bool = false
}

extension OnboardingHighlightView: View {
  var body: some View {
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
            }
            .background(showMemo ? .n20 : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))
          }
          .padding(.horizontal, 20)
          .background(
            GeometryReader { geometry in
              Color.clear
                .preference(key: HighlightRectPreferenceKey.self, value: geometry.frame(in: .named("dimmableVStack")))
            }
          )
          .onTapGesture(count: 1) {
            if isTextHighlighted {
              withAnimation {
                showHighlightTip.toggle()
              }
            }
          }
          .onTapGesture(count: 2) {
            if showDimming {
              withAnimation(.easeInOut) {
                showDimming = false
                isTextHighlighted = true
                tooltipText = "해당 문장이 하이라이트 돼요"
              }
              
              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                  showTooltip = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  tooltipText = "하이라이트 된 문장을 ‘한 번’ 탭하여 \n툴팁을 꺼내요"
                  withAnimation {
                    showTooltip = true
                  }
                }
              }
            }
          }
          
          articleScript3
            .padding(.top, 24)
          articleScript2
            .padding(.top, 40)
          articleScript
            .padding(.top, 40)
          Spacer()
          DesignSystemAsset.toolbarBottom.swiftUIImage
            .resizable()
            .scaledToFit()
            .padding(.bottom, -20)
        }
        
        if showDimming {
          Color.black.opacity(0.7)
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
            .transition(.opacity)
            .allowsHitTesting(false)
        }
        
        if showTooltip && highlightRect != .zero && !showHighlightTip {
          OnboardingToolTipBox(text: tooltipText)
            .position(x: highlightRect.midX, y: highlightRect.maxY + 30)
            .transition(.opacity)
        }
        
        if showHighlightTip && highlightRect != .zero {
          Group {
            if !didChangeColor {
              VStack {
                OnboardingToolTipBoxBottom(text: "원하는 색상을 탭하여\n하이라이트 색상을 변경해요")
                OnboardingHighlightTip(selectedColor: $highlightColor, onMemoTapped: {
                  showMemo = true
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showMemo = false
                  }
                })
              }
            } else {
              VStack(alignment: .trailing) {
                OnboardingToolTipBoxBottomTrailing(text: "메모를 탭 해 메모를 남겨보아요")
                OnboardingHighlightTip(selectedColor: $highlightColor, onMemoTapped: {
                  showMemo = true
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showMemo = false
                  }
                })
              }
            }
          }
          .position(x: highlightRect.midX, y: highlightRect.minY - 60)
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
    .background(Color.background)
    .toolbar(.hidden)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        withAnimation {
          showDimming = true
          tooltipText = "하이라이트 치고 싶은 부분을 \n’두 번’ 탭해요"
        }
      }
    }
  }
}

extension OnboardingHighlightView {
  
  private var articleScriptHeader: some View {
    VStack(spacing: 0) {
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 24)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.leading, 20)
        .padding(.trailing, 80)
        .frame(height: 24)
        .padding(.top, 8)
      
      Text("스크롤을 멈추고 눈에 들어온 한 문장을 표시하는, 그")
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 48)
      
      Text("작은 행동이 정보를 지식으로 바꾸는 시작점이 됩니다.")
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
  }
  private var articleScript3: some View {
    VStack(spacing: 10) {
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.trailing, 220)
        .padding(.leading, 20)
        .frame(height: 16)
    }
  }
  private var articleScript2: some View {
    VStack(spacing: 10) {
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.leading, 20)
        .padding(.trailing, 170)
        .frame(height: 16)
    }
  }
  private var articleScript: some View {
    VStack(spacing: 10) {
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.leading, 20)
        .padding(.trailing, 170)
        .frame(height: 16)
    }
  }
}
