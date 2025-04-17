//
//  RecipeModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 5/1/25.
//

import SwiftUI
import Foundation

// MARK: - FoodRecipeResponse
struct FoodRecipeResponse <T: Codable>: Codable {
    let message: String
    let payload: T
    let statusCode: String
    let timestamp: String
}
// MARK: - FoodRecipeResponseByCuisinseId
struct FoodRecipeResponseByCuisinseId  : Codable {
    let message: String
    let payload: [FoodRecipeByCuisine]
    let statusCode: String
    let timestamp: String
}

// MARK: - FoodRecipePayload
struct FoodRecipePayload: Codable {
    let id: Int
    let photo: [Photo]
    let name: String
    let description: String
    let durationInMinutes: Int
    let level: String
    let cuisineName: String
    let categoryName: String
    var ingredients: [Ingredient]
    let cookingSteps: [CookingStep]
    let totalRaters: Int?
    let averageRating: Double?
    let isFavorite: Bool?
    let itemType: String
    let user: User
    let createdAt: String
    let ratingPercentages: RatingPercentages
}



// MARK: - Ingredient
struct Ingredient: Codable, Identifiable {
    var id: Int
    var name: String
    var quantity: String
    var price: Double

}



// MARK: - CookingStep
struct CookingStep: Codable, Identifiable {
    var id: Int
    var description: String
}

// MARK: - RatingPercentages
struct RatingPercentages: Codable {
    let one: Int
    let two: Int
    let three: Int
    let four: Int
    let five: Int

    enum CodingKeys: String, CodingKey {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
    }
}

//// MARK: - Cuisine Model
//struct CuisineResponse: Codable {
//    let message: String
//    let payload: [Cuisine]
//    let statusCode: String
//    let timestamp: String
//}
//
//struct Cuisine: Codable, Identifiable , Hashable{
//    let id: Int
//    let cuisineName: String
//}

// MARK: - CuisineResponse
struct CuisineResponse: Codable {
    let paginationMeta: PaginationMeta
    let message: String
    let payload: [Cuisine]
    let statusCode: String
    let timestamp: String
}

// MARK: - PaginationMeta
struct PaginationMeta: Codable {
    let totalCategories: Int
    let totalPages: Int
    let currentPage: Int
    let size: Int
    let nextLink: String?
    let prevLink: String?
}

// MARK: - Cuisine
struct Cuisine: Codable, Identifiable, Hashable {
    let id: Int
    let cuisineName: String
}
// MARK: - FoodRecipeByCuisine
struct FoodRecipeByCuisine: Codable, Identifiable {
    let id: Int
    let photo: [Photo]
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

// MARK: - FeedbackResponse
struct FeedbackResponse: Codable {
    let message: String
    let payload: FeedbackPayload
    let statusCode: String
    let timestamp: String
}

// MARK: - FeedbackPayload
struct FeedbackPayload: Codable {
    let feedbackId: Int
    let user: FeedbackUser
    let ratingValue: Int
    let commentText: String
    let createdAt: String
}

// MARK: - FeedbackUser
struct FeedbackUser: Codable {
    let id: Int
    let fullName: String
    let profileImage: String
    let role: String
    let deleted: Bool
}
