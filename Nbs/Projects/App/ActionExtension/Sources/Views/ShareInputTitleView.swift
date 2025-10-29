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
  
  private var isNextButtonDisabled: Bool {
    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedTitle.isEmpty { return true }
    if categories.contains(where: { $0.categoryName == trimmedTitle }) { return true }
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
          .padding(.bottom, 24)
      }
      .padding(.top, 8)
    }
    .onAppear {
      isTitleFieldFocused = true
    }
    .navigationBarBackButtonHidden()
    .frame(minHeight: 258)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .navigationDestination(isPresented: $showNextScreen) {
      ShareSelectIconView(title: title)
    }
  }
  
  private var HeaderView: some View {
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
      Text("카테고리 추가")
        .font(.H4_SB)
        .foregroundStyle(.text1)
      Spacer()
      ConfirmButton(
        title: "다음",
        isOn: !isNextButtonDisabled,
        action: nextButtonTapped
      )
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
          .stroke(.divider1, lineWidth: 1)
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

// MARK: - Notification Name
fileprivate extension Notification.Name {
  static let dismissKeyboard = Notification.Name("dismissKeyboardNotification")
}

#Preview {
  ShareInputTitleView()
}
