//
//  FoodCardComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 30/12/24.
//

import SwiftUI
import Kingfisher
struct FoodCardComponent: View {
    var id: Int?
    @State var isFavorite: Bool
    //    @State var isLike: Bool = false
    var fileName: String
    var name: String
    var description : String
    var level : String
    
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
                    Text(level).foregroundColor(.black.opacity(0.4))
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
            HeartButton2(
                isLiked: $isFavorite, // ideally you’d track this at view level
                foodId: id ?? 112,
                itemType: "FOOD_RECIPE"
                
            )                .
            padding()
        }
        
        .overlay(alignment: .topLeading) {
            TotalStarRating()
                .padding()
        }
    }
}

import SwiftUI
import Kingfisher
struct FoodCardComponent2: View {
    var id: Int?
    @Binding var isFavorite: Bool
    //    @State var isLike: Bool = false
    var fileName: String
    var name: String
    var description : String
    var rating: Double
    var level : String
    
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
                if LanguageDetector.shared.isKhmerText(name){
                    Text(name)
                        .customFontKhmer(size: 14)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                    Text(description)
                        .customFontKhmer(size: 12)
                        .foregroundColor(.black.opacity(0.4))
                        .lineLimit(1)
                }else{
                    Text(name)
                        .customFontRobotoRegular(size: 14)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                    Text(description)
                        .customFontRobotoRegular(size: 12)
                        .foregroundColor(.black.opacity(0.4))
                        .lineLimit(1)
                }
                HStack {
                    Text("_level").foregroundColor(Color(hex: "Primary"))
                    Text(LocalizedStringKey(mapLevel(level: level))).foregroundColor(.black.opacity(0.4))
                }
                .customFontLocalize(size: 10)
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
            HeartButton2(
                isLiked: $isFavorite, // ideally you’d track this at view level
                foodId: id ?? 112,
                itemType: "FOOD_RECIPE"
                
            )                .
            padding()
        }
        
        .overlay(alignment: .topLeading) {
            TotalStarRating(rating: rating)
                .padding()
        }
        .onAppear{
            print("this is food :", id, isFavorite)
        }
    }
    func mapLevel (level: String) -> String {
        switch level {
        case "Easy":
            return "_easy"
        case "Medium":
            return "_medium"
        case "Hard":
            return "_hard"
        default:
            return ""
        }
    }
}
