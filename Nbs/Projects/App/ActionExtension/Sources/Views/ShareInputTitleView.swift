//
//  ShareInputTitleView.swift
//  Nbs
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI
import SwiftData
import DesignSystem
import Domain

// MARK: - Properties
struct ShareInputTitleView: View {
  @Query private var categories: [CategoryItem]

  @Environment(\.dismiss) var dismiss
  @FocusState private var isTitleFieldFocused: Bool
  @State var title: String = ""
  @State private var showNextScreen: Bool = false
  
  private var isDuplicate: Bool {
      let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
      return !trimmedTitle.isEmpty && categories.contains(where: { $0.categoryName == trimmedTitle })
    }
  
  private var isNextButtonDisabled: Bool {
    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedTitle.isEmpty { return true }
    if isDuplicate { return true }
    return false
  }
}

// MARK: - View
extension ShareInputTitleView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(alignment: .center, spacing: 0) {
        Separator()
          .padding(.bottom, 8)
        HeaderView
          .padding(.bottom, 8)
        inputTitleView
          .padding(.bottom, 38)
        MainButton("다음", isDisabled: isNextButtonDisabled) {
          nextButtonTapped()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
      }
      .padding(.top, 8)
    }
    .onAppear {
      isTitleFieldFocused = true
    }
    .navigationBarBackButtonHidden()
    .frame(minHeight: 308)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .navigationDestination(isPresented: $showNextScreen) {
      ShareSelectIconView(title: title)
    }
  }
  
  private var HeaderView: some View {
    ZStack{
      HStack {
        Button {
          dismiss()
        } label: {
          Image(icon: Icon.chevronLeft)
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .tint(.icon)
        }
        .padding(10)
        Spacer()
      }
      Text("새 카테고리")
        .font(.H4_SB)
        .foregroundStyle(.text1)
      Spacer()
    }
    .padding(.vertical, 8)
    .padding(.leading, 4)
    .padding(.trailing, 20)
  }
  
  private var inputTitleView: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("카테고리명")
        .font(.B2_SB)
        .foregroundStyle(.caption1)
      
      VStack(spacing: 4) {
        HStack(spacing: 8) {
          TextField("카테고리명을 입력해주세요", text: $title)
            .focused($isTitleFieldFocused)
            .onChange(of: title) { newValue in
              if newValue.count > 14 {
                title = String(newValue.prefix(14))
              }
            }
            .font(.B1_M)
            .padding(16)
          
          HStack(spacing: 0) {
            Text("\(title.count)")
              .font(.C1)
              .foregroundStyle(.text1)
            Text("/14")
              .font(.C1)
              .foregroundStyle(.caption2)
          }
          .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(.n0)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
          RoundedRectangle(cornerRadius: 12)
            .stroke(isDuplicate ? .danger : .divider1, lineWidth: 1)
        }
      }
      
      if isDuplicate {
        Text("이미 존재하는 카테고리명입니다.")
          .font(.C3)
          .foregroundStyle(.danger)
          .padding(.leading, 6)
      }
    }
    .padding(.horizontal, 20)
  }
}

// MARK: - Method
private extension ShareInputTitleView {
  func nextButtonTapped() {
    NotificationCenter.default.post(name: .dismissKeyboard, object: nil)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      showNextScreen = true
    }
  }
}

#Preview {
  ShareInputTitleView()
}
