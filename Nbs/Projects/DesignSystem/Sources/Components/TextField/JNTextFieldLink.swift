//
//  JNTextFieldLink.swift
//  DesignSystem
//
//  Created by 홍 on 10/30/25.
//

//
//  TextField.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI
import Combine

public struct JNTextFieldLink: View {
  @Binding var text: String
  
  @State var style: JNTextFieldStyle
  let placeholder: String
  let caption: String
  let header: String
  
  @FocusState private var isFocused: Bool
  
  public init(
    text: Binding<String>,
    style: JNTextFieldStyle = .default,
    placeholder: String = "링크를 입력해주세요",
    caption: String = "",
    header: String = ""
  ) {
    self._text = text
    self._style = State(initialValue: style)
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
    case .default, .filled, .foucsed:
      return true
    default:
      return false
    }
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(header)
        .font(.B2_SB)
        .foregroundStyle(.caption1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.leading, 4)
      
      ZStack(alignment: .leading) {
        TextField("", text: textProxy)
          .font(.B1_M)
          .foregroundColor(style.textColor)
          .focused($isFocused)
          .disabled(style == .disabled)
          .padding(.horizontal)
          .frame(height: 56)
          .background(style.backgroundColor)
          .cornerRadius(12)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(isFocused ? JNTextFieldStyle.foucsed.strokeColor : style.strokeColor, lineWidth: 1)
          )
          .onChange(of: text) { _, newValue in
            if !newValue.isEmpty && style == .default {
              style = .filled
            }
          }
        
        if text == "" {
          Text(placeholder)
            .font(.B1_M)
            .foregroundColor(.caption2)
            .padding(.leading, 16)
        }
      }
      
      if style == .errorCaption {
        Text(caption)
          .font(.C3)
          .foregroundColor(.danger)
      }
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  VStack(spacing: 30) {
    Spacer()
    JNTextFieldLink(text: .constant(""), style: .default)
    JNTextFieldLink(text: .constant("hello"), style: .filled)
    JNTextFieldLink(text: .constant("hello"), style: .foucsed)
    JNTextFieldLink(text: .constant(""), style: .disabled)
    JNTextFieldLink(text: .constant("error"), style: .error)
    JNTextFieldLink(text: .constant("errorCapation"), style: .errorCaption, caption: "에러 발생")
    Spacer()
  }
  .background(Color.background)
}
