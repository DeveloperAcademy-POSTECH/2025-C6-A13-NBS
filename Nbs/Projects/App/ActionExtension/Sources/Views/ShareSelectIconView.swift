//
//  ShareSelectIconView.swift
//  Nbs
//
//  Created by 여성일 on 10/18/25.
//

import SwiftUI

import SwiftData

import DesignSystem
import Domain

// MARK: - Properties
struct ShareSelectIconView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) private var modelContext
  @State private var selectedIcon: CategoryIcon? = nil
  
  private var isSaveButtonDisabled: Bool { selectedIcon == nil }
  let title: String
}

// MARK: - View
extension ShareSelectIconView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(alignment: .center, spacing: 0) {
        Separator()
          .padding(.bottom, 8)
        HeaderView
          .padding(.bottom, 8)
        selectCategoryIconView
      }
      .padding(.top, 8)
    }
    .navigationBarBackButtonHidden()
    .frame(minHeight: 258)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
  
  private var HeaderView: some View {
    HStack {
      Button {
        dismiss()
      } label: {
        Image(systemName: "chevron.left")
          .frame(width: 24, height: 24)
          .foregroundStyle(.black)
      }
      .padding(10)
      Spacer()
      Text("카테고리 추가")
        .font(.H4_SB)
        .foregroundStyle(.text1)
      Spacer()
      ConfirmButton(title: "저장", isOn: !isSaveButtonDisabled, action: saveCategory)
    }
    .padding(.vertical, 8)
    .padding(.leading, 4)
    .padding(.trailing, 20)
  }
  
  private var selectCategoryIconView: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("카테고리 아이콘")
        .font(.B2_SB)
        .foregroundStyle(.caption1)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 16) {
          ForEach(1..<16, id: \.self) { icon in
            let icon = CategoryIcon(number: icon)
            
            CategoryButton(
              type: .nontitle,
              icon: icon.name,
              isOn: Binding(
                get: { selectedIcon == icon },
                set: { isOn in
                  if isOn { selectedIcon = icon }
                }
              )
            )
          }
        }
      }
    }
    .padding(.bottom, 32)
    .padding(.horizontal, 20)
  }
}

// MARK: - SwiftData
private extension ShareSelectIconView {
  func saveCategory() {
    guard let selectedIcon = selectedIcon else { return }
    
    let newCategory = CategoryItem(categoryName: title, icon: selectedIcon)
    
    modelContext.insert(newCategory)
    
    do {
      try modelContext.save()
      NotificationCenter.default.post(name: .newCategoryDidSave, object: nil, userInfo: ["newCategory": newCategory])
      NotificationCenter.default.post(name: .closeShareExtension, object: nil)
    } catch {
      print("새 카테고리 저장 실패")
    }
  }
}

// MARK: - Notification Name
fileprivate extension Notification.Name {
  static let newCategoryDidSave = Notification.Name("newCategoryDidSave")
  static let closeShareExtension = Notification.Name("closeShareExtension")
}

// MARK: - Preview
private struct ShareSelectIconViewPreviw: View {
  @State private var title: String = ""
  
  var body: some View {
    ShareSelectIconView(title:"세계")
  }
}

#Preview {
  ShareSelectIconViewPreviw()
}
