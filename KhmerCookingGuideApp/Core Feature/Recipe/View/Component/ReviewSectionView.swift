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
    var totalStarRating: Int 
    var userProfile : String
    var userName : String
    var reviewText : String?
    var isHasThreeDots: Bool
    var onEditTapeed : () -> Void
    var onDeleteTapeed : () -> Void
  
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
            
            if reviewText == "" || totalStarRating == 0 || userName.isEmpty{
                VStack(alignment: .center, spacing: 8) {
                    Text("no_rating_and_feedback_yet")
                        .customFontKhmer(size: 16)
                        .opacity(0.4)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding()
                
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            else{
                // Review Card Section
                ReviewCardView(
                    userProfile: userProfile,
                    userName: userName,
                    reviewText: reviewText ?? "",
                    rating: totalStarRating,
                    isHasThreeDots: isHasThreeDots) {
                        onEditTapeed()
                    }onDeleteTapped: {
                        onDeleteTapeed()
                    }
            }
      
            
            // Write a Review Button
            Button(action: {
                writingReviewButton()
            }) {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("write_a_review")
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


