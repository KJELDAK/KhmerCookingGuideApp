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
                       Text(LocalizedStringKey(placeholder))
                           .font(.custom("KantumruyPro-Regular", size: 16))
                           .padding( [.top],16)

//                            .opacity(0.9)
                            
                        Spacer()
                    }
                }
                
                VStack {
                    TextEditor(text: $text)
                        .padding([.top,.trailing,.bottom],8)
                        .padding(.leading, -4)
                        .padding(.trailing, 4 )
                        .font(.custom("KantumruyPro-Regular", size: 16))

                        .foregroundColor(Color(hex: isTextBlack ? "000000": "737373"))
                        .frame(minHeight: 100, maxHeight: .infinity)
                        .opacity(text.isEmpty ? 0.85 : 1)
                        .lineSpacing(8) // Add space between lines
                          .kerning(1.5)   // Add space between characters
                        
                        
                    Spacer()
                }
            }
        }
    }

