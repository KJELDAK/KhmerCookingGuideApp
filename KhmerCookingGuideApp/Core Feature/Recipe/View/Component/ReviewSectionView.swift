//
//  ReviewSectionView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 14/3/25.
//

import Foundation
import SwiftUI
struct ReviewSectionView: View {
    @State private var selectedRating: Int = 0 // Default rating
    var writingReviewButton: () -> Void
    var totalStarRating: Int = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Tap to Rate Section
            VStack(alignment: .leading, spacing: 8) {
                Text("tap_to_rate")
                    .customFontSemiBoldLocalize(size: 16)
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= selectedRating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                selectedRating = star
                            }
                    }
                }
            }
            
            // Review Card Section
            ReviewCardView(
                userProfile: "mhob1",
                userName: "Sok Reaksa",
                reviewText: "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your profile.",
                rating: totalStarRating
            )
            
            // Write a Review Button
            Button(action: {
                writingReviewButton()
            }) {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Write a Review")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.yellow)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }

        .padding()
    }
}


struct ReviewSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSectionView(writingReviewButton: {})
            .previewLayout(.sizeThatFits)
    }
}
