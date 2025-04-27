//
//  TermsAndConditionsView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 21/4/25.
//


import SwiftUI

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("terms_title")
                        .font(.title)
                        .bold()
                    
                    Text("terms_intro")

                    Group {
                        Text("purpose_title")
                            .font(.headline)
                        Text("purpose_content")

                        Text("responsibility_title")
                            .font(.headline)
                        Text("responsibility_content")

                        Text("content_title")
                            .font(.headline)
                        Text("content_content")

                        Text("modification_title")
                            .font(.headline)
                        Text("modification_content")
                    }

                    Group {
                        Text("privacy_title")
                            .font(.headline)
                        Text("privacy_content")

                        Text("law_title")
                            .font(.headline)
                        Text("law_content")
                    }

                    Divider()

                    Text("agreement_note")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top)

                    Text("thank_you")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle(Text("terms_title"))
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}
