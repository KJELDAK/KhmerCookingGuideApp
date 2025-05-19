//
//  PostFoodModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 16/1/25.
//

import Foundation

struct PostFoodRequest: Codable {
    let photo: [Photo]
    let name: String
    let description: String
    let durationInMinutes: Int
    let level: String
    let cuisineId: Int
    let categoryId: Int
    let ingredients: [Ingredienth]
    let cookingSteps: [CookingStep]
}

struct PostFoodResponse: Codable {
    let message: String
    let payload: FoodRecipe 
    let statusCode: String
    let timestamp: String
}

struct UploadFileResponse: Codable {
    let message: String
    let status: Int
    let payload: [String]
}
