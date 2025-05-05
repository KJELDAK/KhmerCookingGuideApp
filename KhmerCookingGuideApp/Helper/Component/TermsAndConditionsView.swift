//
//  TermsAndConditionsView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 21/4/25.
//

import SwiftUI

struct TermsAndConditionsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("terms_intro")
                        .customFontLocalize(size: 16)

                    Group {
                        Text("purpose_title")
                            .customFontMediumLocalize(size: 18)
                        Text("purpose_content")
                            .customFontLocalize(size: 16)

                        Text("responsibility_title")
                            .customFontMediumLocalize(size: 18)
                        Text("responsibility_content")
                            .customFontLocalize(size: 16)

                        Text("content_title")
                            .customFontMediumLocalize(size: 18)
                        Text("content_content")
                            .customFontLocalize(size: 16)

                        Text("modification_title")
                            .customFontMediumLocalize(size: 18)
                        Text("modification_content")
                            .customFontLocalize(size: 16)
                    }

                    Group {
                        Text("privacy_title")
                            .customFontMediumLocalize(size: 18)
                        Text("privacy_content")
                            .customFontLocalize(size: 16)

                        Text("law_title")
                            .customFontMediumLocalize(size: 18)
                        Text("law_content")
                            .customFontLocalize(size: 16)
                    }

                    Divider()

                    Text("agreement_note")
                        .customFontLocalize(size: 14)
                        .foregroundColor(.secondary)
                        .padding(.top)

                    Text("thank_you")
                        .customFontLocalize(size: 14)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("terms_title")
                        .customFontSemiBoldLocalize(size: 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
