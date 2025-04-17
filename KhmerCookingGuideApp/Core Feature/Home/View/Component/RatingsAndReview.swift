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
    
    private var maxReviewCount: Int {
        starCounts.max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Ratings & Review")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
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
                        let progress = maxReviewCount > 0 ? CGFloat(count) / CGFloat(maxReviewCount) : 0
                        
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


//struct RatingsAndReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        RatingsAndReviewView()
//            .previewLayout(.sizeThatFits)
//    }
//}


