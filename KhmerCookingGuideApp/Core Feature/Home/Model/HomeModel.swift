//
//  File.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 24/12/24.
//

import Foundation
struct CategoryResponsePayload : Codable, Identifiable, Hashable{
   var id : Int
    var categoryName : String
}

import Foundation

// MARK: - Main Response
struct FoodRecipesResponse: Codable {
    let message: String
    let payload: [FoodRecipe]
    let statusCode: String
    let timestamp: String
}

// MARK: - Food Recipe
struct FoodRecipe: Codable, Identifiable {
    let id: Int
    let photo: [Photo]
    let name: String
    let description: String
    let level: String
    let averageRating: Double?
    let totalRaters: Int?
    var isFavorite: Bool
    let itemType: String
    let user: User
}

// MARK: - Photo
struct Photo: Codable , Identifiable{
    var id: Int
    let photo: String
    enum CodingKeys: String ,CodingKey {
        case id = "photoId"
        case photo = "photo"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let fullName: String
    let profileImage: String
}

// MARK: - PopularFoodResponse Model
struct PopularFoodResponse: Codable {
    let message: String
    let payload: PopularFoodPayload
    let statusCode: String
    let timestamp: String
}

// MARK: - Payload Model
struct PopularFoodPayload: Codable {
    let popularSells: [String] // Assuming an empty array for now
    let popularRecipes: [PopularRecipe]
}
// MARK: - view recipe by category model Model
struct ViewRecipeByCategory: Codable {
    let message : String
    let payload: ViewRecipeByCategoryPayload
    let statusCode: String
    let timestamp: String
}
// MARK: - Payload Model
struct ViewRecipeByCategoryPayload: Codable{
    let popularRecipes: [PopularRecipe]
    let popularSells: [String] // Assuming an empty array for now
}
// MARK: - Popular Recipe Model
struct PopularRecipe: Codable, Identifiable {
    let id: Int
    let photo: [RecipePhoto]
    let name: String
    let description: String
    let level: String
    let averageRating: Double?
    let totalRaters: Int?
    var isFavorite: Bool?
    let itemType: String
    let user: RecipeUser
}

// MARK: - Recipe Photo Model
struct RecipePhoto: Codable {
    let photoId: Int
    let photo: String
}

// MARK: - User Model
struct RecipeUser: Codable {
    let id: Int
    let fullName: String
    let profileImage: String
}
///
///
/// import Foundation

// MARK: - Main Response
struct FoodResponse: Codable {
    let message: String
    let payload: CaytegoryPayload
    let statusCode: String
    let timestamp: String
}

// MARK: - Payload
struct CaytegoryPayload: Codable {
    let foodRecipes: [FoodRecipeInCategory]
    let foodSells: [FoodSell] // Assuming foodSells is an array of similar objects (empty in your example)
}

// MARK: - Food Recipe
struct FoodRecipeInCategory: Codable, Identifiable {
    let id: Int
    let photo: [FoodPhoto]
    let name: String
    let description: String
    let level: String
    let averageRating: Double?
    let totalRaters: Int?
    let itemType: String
    let user: User
    var isFavorite: Bool? // ✅ MUST BE OPTIONAL
}



// MARK: - Food Photo
struct FoodPhoto: Codable, Identifiable {
    let photoId: Int
    let photo: String
    
    var id: Int { photoId }
}


// MARK: - Food Sell (Empty Array in Example)
struct FoodSell: Codable {} // Define this if needed


