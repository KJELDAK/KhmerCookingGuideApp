//
//  RatingsAndReview.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 8/1/25.
//

import SwiftUI
import SwiftUI

struct RatingsAndReviewView: View {
    var averageRating: Double
    var reviewCount: Int
    var onTappAction: () -> Void
    func calculateStarDistribution(averageRating: Double, totalReviews: Int) -> [Int] {
        guard totalReviews > 0 else { return [0, 0, 0, 0, 0] }

        let percentageWeights: [Double]
        
        switch averageRating {
        case 4.5...5.0:
            percentageWeights = [0.02, 0.03, 0.05, 0.2, 0.7] // Mostly 5-star ratings
        case 3.5..<4.5:
            percentageWeights = [0.05, 0.1, 0.2, 0.35, 0.3]  // Balanced between 3-5 stars
        case 2.5..<3.5:
            percentageWeights = [0.1, 0.15, 0.35, 0.25, 0.15] // Mostly 3-star ratings
        case 1.5..<2.5:
            percentageWeights = [0.2, 0.3, 0.25, 0.15, 0.1]   // Mostly 1-2 stars
        default:
            percentageWeights = [0.5, 0.3, 0.1, 0.05, 0.05]   // Mostly 1-star ratings
        }
        return percentageWeights.map { Int(round($0 * Double(totalReviews))) }
    }
    private var starCounts: [Int] {
        calculateStarDistribution(averageRating: averageRating, totalReviews: reviewCount)
    }
    // Calculate the percentage of reviews for each star count
    private func progressForStar(starCount: Int) -> CGFloat {
        let totalReviews = CGFloat(reviewCount)
        let starReviewCount = CGFloat(starCounts[starCount - 1])
        
        return totalReviews > 0 ? starReviewCount / totalReviews : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack{
                // Title
                Text("ratings_and_review")
                    .customFontSemiBoldLocalize(size: 20)
                    .foregroundColor(.black)
                Image("angle-right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .rotationEffect(.degrees(-90))
            }
            .onTapGesture {
                onTappAction()
            }
            // Rating and Review Summary
            HStack(alignment: .top, spacing: 20) {
                // Left: Average Rating
                VStack {
                    Text(String(format: "%.1f", averageRating))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("out of 5")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .frame(width: 100, alignment: .leading)
                
                // Right: Stars and Progress Bars
                VStack(alignment: .trailing, spacing: 8) {
                    ForEach((1...5).reversed(), id: \.self) { starCount in
                        let count = starCounts[starCount - 1]
                        let progress = progressForStar(starCount: starCount)
                        
                        HStack {
                            // Star Icons
                            HStack(spacing: 2) {
                                ForEach(0..<starCount, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.yellow)
                                }
                            }
                            .frame(width: 70, alignment: .trailing)
                          
                            // Progress Bar
                            ProgressView(value: progress)
                                .frame(height: 8)
                                .tint(Color.blue)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                // Total Ratings Count
                Text("\(reviewCount) Ratings")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
// MARK: - Top-level server response
struct RatingFeedbackResponse: Codable {
    let message: String
    let payload: [RatingFeedback]
    let statusCode: String
    let timestamp: String
}

// MARK: - Individual feedback entry
struct RatingFeedback: Codable, Identifiable {
    let id: Int
    let user: FeedbackUser
    let ratingValue: Int
    let commentText: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "feedbackId"
        case user, ratingValue, commentText, createdAt
    }
}

