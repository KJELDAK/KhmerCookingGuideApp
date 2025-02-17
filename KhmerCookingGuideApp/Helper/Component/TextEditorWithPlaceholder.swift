//
//  TextEditorWithPlaceholder.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 17/1/25.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    var placeholder: String
    @Binding var isTextBlack : Bool
        var body: some View {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                   VStack {
                       Text(placeholder)
//                           .customFont(size: 16)
                            .padding(.top, 10)
//                            .padding(.leading, 6)
//                            .opacity(0.9)
                            
                        Spacer()
                    }
                }
                
                VStack {
                    TextEditor(text: $text)
                        .padding(.vertical,10)
                        .customFont(size: 16)
                        .foregroundColor(Color(hex: isTextBlack ? "000000": "737373"))
                        .frame(minHeight: 100, maxHeight: .infinity)
                        .opacity(text.isEmpty ? 0.85 : 1)
                        
                    Spacer()
                }
            }
        }
    }

