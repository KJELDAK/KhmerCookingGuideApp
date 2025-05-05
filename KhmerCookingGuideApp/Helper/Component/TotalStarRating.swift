//
//  TotalStarRating.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 1/1/25.
//

import SwiftUI

struct TotalStarRating: View {
    var rating: Double = 0
    var body: some View {
        VStack {
            HStack {
                Image("star")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 7, height: 7)
                Text(String(rating))
                    .customFontMedium(size: 10)
            }
        }
        .frame(width: 60, height: 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white) // Background fill color (optional)
                .shadow(color: Color(hex: "FFC529").opacity(0.2), radius: 4, x: 0, y: 2) // Add shadow here
        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(Color(hex: "FFC529"), lineWidth: 0.0)
//        )
    }
}

#Preview {
    TotalStarRating()
}
