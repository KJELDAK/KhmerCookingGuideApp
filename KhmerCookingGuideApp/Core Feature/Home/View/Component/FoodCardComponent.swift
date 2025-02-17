//
//  FoodCardComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 30/12/24.
//

import SwiftUI
import Kingfisher
struct FoodCardComponent: View {
    @State var isLike: Bool = false
    var fileName: String
    var name: String
    var description : String
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/\(fileName)"

        VStack(spacing: 0) {
            // Image Section
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(height: 135) // Directly setting height
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(15, corners: [.topLeft, .topRight])
            
            // Text Section
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .customFontMedium(size: 14)
                    .foregroundColor(Color.black)
                    .lineLimit(1)
                Text(description)
                    .customFont(size: 12)
                    .foregroundColor(.black.opacity(0.4))
                    .lineLimit(1)
                HStack {
                    Text("Level").foregroundColor(Color(hex: "Primary"))
                    Text("Easy").foregroundColor(.black.opacity(0.4))
                }
                .customFont(size: 10)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 70)
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        }
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 2)
        )
        .overlay(alignment: .topTrailing) {
            HeartButton(isLiked: $isLike)
                .padding()
        }
        .overlay(alignment: .topLeading) {
            TotalStarRating()
                .padding()
        }
    }
}
//#Preview {
//    FoodCardComponent(isLike: true, fileName: "aa39e776-45df-422d-a68b-25504d1e6b15.png", name: "amok")
//}
