//
//  FavoriteModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 5/1/25.
//

import SwiftUI
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
    var isFavorite: Bool
    let itemType: String
    let user: User
}

// MARK: - Placeholder for sells

struct FavoriteFoodSell: Codable {}
