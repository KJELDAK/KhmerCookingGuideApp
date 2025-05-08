//
//  LanguageSelectionView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 21/4/25.
//
import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var showLanguageSheet: Bool
    @State private var Langeselected: String = ""

    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    func handleSelected() {
        languageManager.setLanguage(displayName: Langeselected) // Update the language in LanguageManager
        showLanguageSheet = false
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("_language")
                .customFontSemiBoldLocalize(size: 24)

            VStack(alignment: .leading, spacing: 15) {
                Text("please_select_a_display_language")
                    .customFontLocalize(size: 18)
                    .foregroundColor(.gray)

                LanguageOption(language: "_khmer", flag: "khmerLogo", isSelected: $Langeselected)
                LanguageOption(language: "_english", flag: "usa", isSelected: $Langeselected)
            }
            .padding(.vertical, 10)
            .padding(.bottom, 20)

            ButtonComponent(action: {
                handleSelected()
            }, content: "_select")
                .padding(.bottom)
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
        .presentationDetents([
            screenWidth <= 375 ? .height(330) : .height(340),
            screenWidth <= 375 ? .height(330) : /* .medium */ .height(340),
        ])
        .presentationBackground(.white)
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
        .background(Color.white)
        .cornerRadius(20)
        .onAppear {
            Langeselected = languageManager.displayName // Initialize with the current language
        }
    }
}

import SwiftUI

struct LanguageOption: View {
    let language: String
    let flag: String
    @Binding var isSelected: String

    var body: some View {
        GeometryReader {
            _ in
            Button(action: {
                isSelected = language
            }) {
                HStack {
                    Image(flag)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .scaledToFill()
                        .padding(.vertical, -10)
                        .padding(.trailing, 20)

                    Text(LocalizedStringKey(language))
                        .font(.system(size: 18, weight: isSelected == language ? .semibold : .medium))
                        .foregroundColor(.primary)
                    Spacer()

                    if isSelected == language {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                            .font(.system(size: 24, weight: .bold))
                    }
                }
//                .frame(minWidth: 200,maxWidth: geo.size.width * 0.9)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSelected == language ? Color.blue.opacity(0.1) : .clear)
                .cornerRadius(15)
            }
        }
    }
}
