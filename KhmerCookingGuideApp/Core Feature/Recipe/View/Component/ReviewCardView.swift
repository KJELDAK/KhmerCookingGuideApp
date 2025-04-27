//
//  ReviewCardView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 14/3/25.
//

import SwiftUI
import Kingfisher
struct ReviewCardView: View {
    var userProfile: String
    var userName : String
    var reviewText: String
    var rating: Int

    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        VStack(alignment: .leading, spacing: 8) {
            // Review Title
            HStack {
                if userProfile == "default.jpg"{
                    Image("defaultPFMale")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                }
                else{
                    KFImage(URL(string: imageUrl + "\(userProfile)"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                }
                
                Text(userName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            }
            
            // Star Rating Display
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: index < rating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.yellow)
                }
            }

            // Review Text
            Text(reviewText)
                .font(.system(size: 14))
                .foregroundColor(Color(.darkGray))
                
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
