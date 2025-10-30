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
  @State var internalCaption: String
  let header: String
  @Binding var isValidURL: Bool
  
  @FocusState private var isFocused: Bool
  
  public init(
    text: Binding<String>,
    style: JNTextFieldStyle = .default,
    placeholder: String = "링크를 입력해주세요",
    caption: String = "",
    header: String = "",
    isValidURL: Binding<Bool> = .constant(true)
  ) {
    self._text = text
    self._style = State(initialValue: style)
    self.placeholder = placeholder
    self._internalCaption = State(initialValue: caption)
    self.header = header
    self._isValidURL = isValidURL
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
  
  private func validateURL() {
    let urlRegex = """
    ^(https?|ftp)://([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&%$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])|([a-zA-Z0-9-]+\\.)*[a-zA-Z0-9-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(:[0-9]+)*(\\/($|[a-zA-Z0-9.,?'\\+&%$#=~_\\-]+))*$
    """
    let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegex)
    
    if text.isEmpty {
      isValidURL = true
      internalCaption = ""
    } else if urlTest.evaluate(with: text) {
      isValidURL = true
      internalCaption = ""
    } else {
      isValidURL = false
      internalCaption = "유효하지 않은 URL"
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
              .stroke(style == .errorCaption ? JNTextFieldStyle.errorCaption.strokeColor : (isFocused ? JNTextFieldStyle.foucsed.strokeColor : style.strokeColor), lineWidth: 1)
          )
          .onChange(of: text) { _, newValue in
            validateURL()
            if !isValidURL {
              style = .errorCaption
            } else if !newValue.isEmpty {
              style = .filled
            } else {
              style = .default
            }
          }
        
        if text == "" {
          Text(placeholder)
            .font(.B1_M)
            .foregroundColor(.caption2)
            .padding(.leading, 16)
        }
      }
      
//      if style == .errorCaption {
//        Text(internalCaption)
//          .font(.C3)
//          .foregroundColor(.danger)
//      }
    }
    .padding(.horizontal, 20)
    .onAppear(perform: validateURL)
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
