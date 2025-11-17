//
//  TextField.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI
import Combine

fileprivate struct Shake: GeometryEffect {
  var amount: CGFloat = 10
  var shakesPerUnit = 3
  var animatableData: CGFloat
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
  }
}

public struct JNTextField: View {
  @Binding var text: String
  @Binding var style: JNTextFieldStyle
  let placeholder: String
  let caption: String
  let header: String
  @FocusState private var isFocused: Bool
  @State private var shakeCount: CGFloat = 0
  
  public init(
    text: Binding<String>,
    style: Binding<JNTextFieldStyle> = .constant(.default),
    placeholder: String = "링크를 입력해주세요",
    caption: String = "",
    header: String = ""
  ) {
    self._text = text
    self._style = style
    self.placeholder = placeholder
    self.caption = caption
    self.header = header
  }
  
  private var textProxy: Binding<String> {
    Binding<String>(
      get: { self.isTextVisible ? self.text : "" },
      set: { self.text = $0 }
    )
  }
  
  private var isTextVisible: Bool {
    switch style {
    case .default, .filled, .foucsed, .error, .errorCaption:
      return true
    default:
      return false
    }
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(header)
        .font(.B2_SB)
        .foregroundStyle(.caption1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
        .padding(.leading, 4)
      
      ZStack(alignment: .leading) {
        TextField("", text: textProxy)
          .font(.B1_M)
          .foregroundColor(style.textColor)
          .focused($isFocused)
          .disabled(style == .disabled)
          .padding()
          .frame(height: 56)
          .background(style.backgroundColor)
          .cornerRadius(12)
          .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
              Spacer()
              Button("완료") {
                isFocused = false
              }
            }
          }
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(isFocused ? JNTextFieldStyle.foucsed.strokeColor : style.strokeColor, lineWidth: 1)
          )
          .onReceive(Just(text)) { _ in
            if text.count > 14 {
              text = String(text.prefix(14))
            }
            
            if !text.isEmpty && style == .default {
              style = .filled
            }
          }
        
        HStack(spacing: 0) {
          Spacer()
          Text("\(text.count)")
            .font(.C3)
            .foregroundStyle(.text1)
          
          Text("/14")
            .font(.C3)
            .foregroundStyle(.caption2)
            .padding(.trailing, 16)
        }
        
        if text.isEmpty {
          Text(placeholder)
            .font(.B1_M)
            .foregroundColor(.caption2)
            .padding(.leading, 16)
        }
      }
      .modifier(Shake(animatableData: shakeCount))
      .onChange(of: style) { _, newValue in
        guard newValue == .error || newValue == .errorCaption else { return }
        withAnimation(.default) {
          shakeCount += 1
        }
      }
      
      if style == .errorCaption {
        Text(caption)
          .font(.C3)
          .foregroundColor(.danger)
          .padding(.leading, 4)
      }
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  VStack(spacing: 30) {
    Spacer()
    JNTextField(text: .constant(""), style: .constant(.default), header: "String")
      .background(Color.green)
//    JNTextField(text: .constant("hello"), style: .filled)
//    JNTextField(text: .constant("hello"), style: .foucsed)
//    JNTextField(text: .constant(""), style: .disabled)
//    JNTextField(text: .constant("error"), style: .error)
//    JNTextField(text: .constant("errorCapation"), style: .errorCaption, caption: "에러 발생")
    Spacer()
  }
  .background(Color.background)
}
