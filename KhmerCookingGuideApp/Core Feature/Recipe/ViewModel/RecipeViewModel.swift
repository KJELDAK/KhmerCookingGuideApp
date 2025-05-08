//
//  RecipeViewModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 5/1/25.
//

import Alamofire
import SwiftUI
class RecipeViewModel: ObservableObject {
    @Published var viewRecipeById: FoodRecipePayload?
    @Published var isLoading: Bool = false
    @Published var cuision: [Cuisine] = []
    @Published var viewAllRecipeByCuisineId: [FoodRecipeByCuisine] = []
    @Published var viewAllRateAndFeedBack: [RatingFeedback] = []
    @Published var userFoodFeedback: UserFoodFeedbackResponse?
    @Published var isLoadingWhenPerfromAction: Bool = false
    func fetchRecipeById(id: Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/foods/detail/\(id)?itemType=FOOD_RECIPE"
        isLoading = true
        print(url)
        AF.request(url, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: FoodRecipeResponse<FoodRecipePayload>.self) { response in
                switch response.result {
                case let .success(vale):
                    self.viewRecipeById = vale.payload
                    self.isLoading = false
                    completion(true, "get food recipe by id success")
                case let .failure(error):
                    self.isLoading = false
                    if let data = response.data {
                        //                        print(String(data: data, encoding: .utf8) ?? "Invalid UTF8 data")
                        if let severError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        print("faild to get all categories")
                        completion(false, error.localizedDescription)
                    }
                }
            }
    }

    func getAllCuisine(completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/cuisine/all?page=0&size=10"
        AF.request(url, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: CuisineResponse.self) { response in
                switch response.result {
                case let .success(value):
                    self.cuision = value.payload
                    completion(true, value.message)
                case let .failure(error):
                    completion(false, error.localizedDescription)
                }
            }
    }

    func getAllFoodRecipeByCuisineId(cuisineId: Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/food-recipe/cuisine/\(cuisineId)"
        isLoading = true
        AF.request(url, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: FoodRecipeResponseByCuisinseId.self) { response in
                switch response.result {
                case let .success(value):
                    self.viewAllRecipeByCuisineId = value.payload
                    completion(true, value.message)
                    self.isLoading = false
                case let .failure(error):
                    self.isLoading = false
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print(severError.payload)
                            completion(false, severError.payload)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        print("faild to get all categories")
                        completion(false, error.localizedDescription)
                    }
                }
            }
    }

    func getAllRateAndFeedback(foodId: Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/feedback/guest-user/\(foodId)?itemType=FOOD_RECIPE"
        isLoading = true
        print("get all rate and feedback url: \(url)")

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: RatingFeedbackResponse.self) { response in
                switch response.result {
                case let .success(value):
                    self.viewAllRateAndFeedBack = value.payload
                    completion(true, value.message)

                case let .failure(error):
                    self.isLoading = false
                    if let data = response.data {
                        if let serverError = try? JSONDecoder().decode(RateAndFeedbackErrorResponse.self, from: data) {
                            print("Server error: \(serverError.detail)")
                            completion(false, serverError.detail)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        print("Failed to fetch feedbacks")
                        completion(false, error.localizedDescription)
                    }
                }
            }
    }

    func getFeedBackByFoodItemForCurrentUser(foodId: Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/feedback/\(foodId)?itemType=FOOD_RECIPE"

        isLoading = true
        print("get all rate and feedback url: \(url)")

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: UserFoodFeedbackResponse.self) { response in
                switch response.result {
                case let .success(value):
                    self.userFoodFeedback = value
                    completion(true, value.message)

                case let .failure(error):
                    self.isLoading = false
                    if let data = response.data {
                        if let serverError = try? JSONDecoder().decode(RateAndFeedbackErrorResponse.self, from: data) {
                            print("Server error: \(serverError.detail)")
                            completion(false, serverError.detail)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        print("Failed to fetch feedbacks")
                        completion(false, error.localizedDescription)
                    }
                }
            }
    }

    func postRateAndFeedback(foodId: Int, ratingValue: String, commentText: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/feedback?itemType=FOOD_RECIPE"
        isLoading = true
        print("post rate and feedback url: \(url)")
        let parameter: [String: Any] = [
            "foodId": foodId,
            "ratingValue": ratingValue,
            "commentText": commentText,
        ]
        print("post rate and feedback url: \(url)")
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: FeedbackResponse.self) { response in
                switch response.result {
                case let .success(value):
                    print(value.message)
                    completion(true, value.message)
                case let .failure(error):
                    self.isLoading = false
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(RateAndFeedbackErrorResponse.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        print("faild to get all categories")
                        completion(false, "technical_error")
                    }
                }
            }
    }

    func updateRateAndFeedback(feedBackId: Int, foodId: Int, ratingValue: String, commentText: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/feedback/\(feedBackId)"
        isLoading = true
        let parameter: [String: Any] = [
            "foodId": foodId,
            "ratingValue": ratingValue,
            "commentText": commentText,
        ]
        AF.request(url, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: FeedbackResponse.self) { response in
                switch response.result {
                case let .success(value):
                    print(value.message)
                    completion(true, value.message)
                case let .failure(error):
                    self.isLoading = false
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(RateAndFeedbackErrorResponse.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        completion(false, error.localizedDescription)
                    }
                }
            }
    }

    func deleteRateAndFeedbackById(id: Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/feedback/\(id)"
        isLoadingWhenPerfromAction = true
        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: ResponseWrapper<String>.self) { response in
                switch response.result {
                case let .success(value):
                    self.viewAllRateAndFeedBack.removeLast()
                    self.userFoodFeedback = nil

                    completion(true, value.message)
                    self.isLoadingWhenPerfromAction = false
                case let .failure(error):
                    self.isLoadingWhenPerfromAction = false
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ResponseWrapper<String>.self, from: data) {
                            print(severError.message)
                            completion(false, severError.message)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        completion(false, error.localizedDescription)
                    }
                }
            }
    }

    func deleteRecipeById(id: Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/food-recipe/delete/\(id)"
        print(url)
        isLoadingWhenPerfromAction = true
        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: ResponseWrapper<String>.self) { response in
                switch response.result {
                case let .success(value):
                    completion(true, value.message)
                    self.isLoadingWhenPerfromAction = false
                case let .failure(error):
                    self.isLoadingWhenPerfromAction = false
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ResponseWrapper<String>.self, from: data) {
                            print(severError.message)
                            completion(false, severError.message)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        completion(false, error.localizedDescription)
                    }
                }
            }
    }
}

import Foundation

// MARK: - Feedback Response for Food Item by Current User

struct UserFoodFeedbackResponse: Codable {
    let message: String
    let payload: RatingFeedback?
    let statusCode: String
    let timestamp: String
}
