//
//  FavoritesView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var favoriteViewModel = FavoriteViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if favoriteViewModel.favoriteList.isEmpty {
                    // Empty State
                    VStack {
                        Image(systemName: "star")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No Favorites Yet")
                            .font(.headline)
                            .padding(.top)
                        Text("Start exploring delicious Khmer recipes and save your favorites here!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        ButtonComponent(action: {
                            // Handle navigation or action
                        }, content: "Discover Recipes")
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteViewModel.favoriteList) { recipe in
                                if let firstPhoto = recipe.photo.first {
                                    NavigationLink(
                                        destination: RecipeDetails(id: recipe.id).navigationBarHidden(true)
                                    ) {
                                        FoodCardComponent(isFavorite: recipe.isFavorite, fileName: firstPhoto.photo, name: recipe.name, description: recipe.description)
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .navigationTitle("Favorites")
                }
            }
            .onAppear {
                favoriteViewModel.getAllFavoriteFoodRecipes { success, message in
                    print("Fetch status: \(success), message: \(message)")
                }
            }
        }
    }
}


import Foundation

// MARK: - Root Response
struct FavoriteFoodsResponse: Codable {
    let message: String
    let payload: FavoriteFoodsPayload
    let statusCode: String
    let timestamp: String
}

// MARK: - Payload
struct FavoriteFoodsPayload: Codable {
    let favoriteFoodSells: [FavoriteFoodSell] // Placeholder if needed later
    let favoriteFoodRecipes: [FavoriteFoodRecipe]
}

// MARK: - Recipe
struct FavoriteFoodRecipe: Codable, Identifiable {
    let id: Int
    let photo: [RecipePhoto]
    let name: String
    let description: String
    let level: String
    let durationInMinutes: Int
    let averageRating: Double?
    let totalRaters: Int?
    let isFavorite: Bool
    let itemType: String
    let user: User
}





// MARK: - Placeholder for sells
struct FavoriteFoodSell: Codable {}



struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
