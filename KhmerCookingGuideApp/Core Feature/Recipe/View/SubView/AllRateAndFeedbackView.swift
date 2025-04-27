//
//  AllRateAndFeedbackView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/4/25.
//

import SwiftUI

struct AllRateAndFeedbackView: View {
    var rateAndFeebackPayload: [RatingFeedback]

    var body: some View {
        NavigationView {
            ScrollView {
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
            .navigationTitle("All Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
