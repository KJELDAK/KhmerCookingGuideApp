//
//  RecipeModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 5/1/25.
//

import Foundation
import SwiftUI

// MARK: - FoodRecipeResponse

struct FoodRecipeResponse<T: Codable>: Codable {
    let message: String
    let payload: T
    let statusCode: String
    let timestamp: String
}

// MARK: - FoodRecipeResponseByCuisinseId

struct FoodRecipeResponseByCuisinseId: Codable {
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

struct RatingPercentages: Codable {
    let one: Double
    let two: Double
    let three: Double
    let four: Double
    let five: Double

    enum CodingKeys: String, CodingKey {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
    }
}

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
    var isFavorite: Bool
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

struct RateAndFeedbackErrorResponse: Codable {
    let type: String
    let title: String
    let status: Int
    let detail: String
    let instance: String
    let timestamp: String
}
