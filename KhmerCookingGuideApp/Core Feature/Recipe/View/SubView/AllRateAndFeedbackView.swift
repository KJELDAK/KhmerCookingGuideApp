//
//  AllRateAndFeedbackView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/4/25.
//

import SwiftUI

struct AllRateAndFeedbackView: View {
    var rateAndFeebackPayload: [RatingFeedback]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                if rateAndFeebackPayload.isEmpty {
                    VStack {
                        Spacer(minLength: 150) // Push down a bit from top
                        Text("no_rating_and_feedback_yet")
                            .customFontKhmer(size: 16)
                            .opacity(0.4)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(rateAndFeebackPayload) { feedback in
                            ReviewCardView(
                                userProfile: feedback.user.profileImage,
                                userName: feedback.user.fullName,
                                reviewText: feedback.commentText,
                                rating: feedback.ratingValue
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
            .toolbar {
                ToolbarItem( placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Image("backButton")
                    }
                }
            }
            .navigationTitle("All Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
