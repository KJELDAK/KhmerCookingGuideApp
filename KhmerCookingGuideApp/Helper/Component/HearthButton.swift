//
//  HearthButton.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 30/12/24.
//

import SwiftUI

struct HeartButton: View {
    @Binding var isLiked: Bool // State to track if the heart is liked
    
    var body: some View {
        Button(action: {
            isLiked.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(isLiked ? Color.red : Color.white.opacity(0.3))
                    .frame(width: 28, height: 28)
                                    Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            }
        }
        //        .buttonStyle(.plain) // Removes default button styling
    }
}
struct HeartButton2: View {
    @Binding var isLiked: Bool
    let foodId: Int
    let itemType: String
    @StateObject var viewModel = FavoriteViewModel()
    
    var body: some View {
        Button(action: {
            if isLiked {
                viewModel.removeFavorite(foodId: foodId, itemType: itemType) { success, message in
                    if success {
                        isLiked = false
                    }
                    print("💔 Remove:", message)
                }
            } else {
                viewModel.addToFavorite(foodId: foodId, itemType: itemType) { success, message in
                    if success {
                        isLiked = true
                    }
                    print("❤️ Add:", message)
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(isLiked ? Color.red : Color.white.opacity(0.3))
                    .frame(width: 28, height: 28)
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            }
        }
    }
}

