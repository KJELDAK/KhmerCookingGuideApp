//
//  RatingsAndReview.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 8/1/25.
//

import SwiftUI
import SwiftUI

struct RatingsAndReviewView: View {
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
                    Text("4.8")
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
                        HStack {
                            // Star Icons
//                            HStack(spacing: 2) {
//                                ForEach(0..<5) { index in
//                                    Image(systemName: index < starCount ? "star.fill" : "star")
//                                        .resizable()
//                                        .frame(width: 12, height: 12)
//                                        .foregroundColor(.yellow)
//                                }
//                            }
                            HStack(spacing: 2) {
                                ForEach(0..<starCount, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.yellow)
                                }
                            }.frame(width: 70,alignment: .trailing)
                          
                            // Progress Bar
                            ProgressView(value: CGFloat(starCount) * 0.2, total: 1.0)
                                .frame(height: 8)
                                .tint(Color.blue)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            HStack{
                Spacer()
                // Total Ratings Count
                Text("2346 Ratings")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct RatingsAndReviewView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsAndReviewView()
            .previewLayout(.sizeThatFits)
    }
}


