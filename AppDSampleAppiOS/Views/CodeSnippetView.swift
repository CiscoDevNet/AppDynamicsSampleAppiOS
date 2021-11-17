//
//  CodeSnippetView.swift
//  AppDSampleAppiOS

import Foundation
import SwiftUI

struct CodeSnippetView: UIViewRepresentable {

    // Font size 12.0 fits well on iPhone Plus devices,
    // but not on non-Plus ones, thus we're using 10.0
    let fontSize: CGFloat = 10.0
    var text: String
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        textView.isSelectable = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
 
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        uiView.selectAll(nil)
    }
}

struct CodeSnippetView_Previews: PreviewProvider {
    static var previews: some View {
        CodeSnippetView(text: "/* preview */")
    }
}

