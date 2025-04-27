//
//  RecipeViewModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 5/1/25.
//

import SwiftUI
import Alamofire
class RecipeViewModel: ObservableObject {
    @Published var viewRecipeById : FoodRecipePayload?
    @Published var isLoading : Bool = false
    @Published var cuision : [Cuisine] = []
    @Published var viewAllRecipeByCuisineId : [FoodRecipeByCuisine] = []
    @Published var viewAllRateAndFeedBack : [RatingFeedback] = []
    @Published var userFoodFeedback : UserFoodFeedbackResponse?
    func fetchRecipeById(id : Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/foods/detail/\(id)?itemType=FOOD_RECIPE"
        isLoading = true
        print(url)
        AF.request(url, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: FoodRecipeResponse<FoodRecipePayload>.self) { response in
                switch response.result{
                case .success(let vale):
                    self.viewRecipeById = vale.payload
                    self.isLoading = false
                    completion(true,"get food recipe by id success")
                case .failure(let error):
                    self.isLoading = false
                    if let data = response.data{
                        if let severError = try? JSONDecoder().decode(ErrorResponse.self, from: data){
                            print(severError.detail)
                            completion(false,severError.detail)
                        }
                        else{
                            completion(false,error.localizedDescription)
                        }
                        
                    }
                    else{
                        print("faild to get all categories")
                        completion(false, error.localizedDescription)
                    }
                    
                }
            }
    }
    func getAllCuisine(completion: @escaping(Bool, String)-> Void){
        let url = "\(API.baseURL)/cuisine/all?page=0&size=10"
        AF.request(url,encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: CuisineResponse.self) { response in
                switch response.result {
                case .success(let value):
                    self.cuision = value.payload
                    completion(true, value.message)
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
    }
    func getAllFoodRecipeByCuisineId(cuisineId: Int, completion: @escaping(Bool, String)-> Void){
        let url = ("\(API.baseURL)/food-recipe/cuisine/\(cuisineId)")
        self.isLoading = true
        AF.request(url,encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of:FoodRecipeResponseByCuisinseId.self) { response in
                switch response.result{
                case .success(let value):
                    print("get recipe by cuisine id success")
                    self.viewAllRecipeByCuisineId = value.payload
                    completion(true, value.message)
                    self.isLoading = false
                case .failure(let error):
                    self.isLoading = false
                    if let data = response.data{
                        if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data){
                            print(severError.payload)
                            completion(false,severError.payload)
                        }
                        else{
                            completion(false,error.localizedDescription)
                        }
                        
                    }
                    else{
                        print("faild to get all categories")
                        completion(false, error.localizedDescription)
                    }
                }
            }
        
    }
    func getAllRateAndFeedback(foodId: Int, completion: @escaping (Bool ,String) -> Void) {
        let url = "\(API.baseURL)/feedback/guest-user/\(foodId)?itemType=FOOD_RECIPE"
        self.isLoading = true
        print("get all rate and feedback url: \(url)")

        AF.request(url, method: .get, encoding: JSONEncoding.default,headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: RatingFeedbackResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print("Successfully fetched feedbacks: \(value.payload)")
                    self.viewAllRateAndFeedBack = value.payload
                    completion(true, value.message)

                case .failure(let error):
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
    func getFeedBackByFoodItemForCurrentUser(foodId: Int, completion: @escaping (Bool ,String) -> Void) {
        let url = "\(API.baseURL)/feedback/\(foodId)?itemType=FOOD_RECIPE"
       
        self.isLoading = true
        print("get all rate and feedback url: \(url)")

        AF.request(url, method: .get, encoding: JSONEncoding.default,headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: UserFoodFeedbackResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print("Successfully fetched feedbacks: \(value.payload)")
                    self.userFoodFeedback = value
                    completion(true, value.message)

                case .failure(let error):
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


    func postRateAndFeedback(foodId: Int, ratingValue: String, commentText: String, completion: @escaping (Bool, String) -> Void){
        let url = ("\(API.baseURL)/feedback?itemType=FOOD_RECIPE")
        self.isLoading = true
        print("post rate and feedback url: \(url)")
        let parameter: [String: Any] = [
            "foodId": foodId,
            "ratingValue": ratingValue,
            "commentText": commentText,
        ]
        print("ajaj", parameter)
        print("post rate and feedback url: \(url)")
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: FeedbackResponse.self){ response in
                switch response.result{
                case .success(let value):
                    completion(true, value.message)
                case .failure(let error):
                    self.isLoading = false
                    if let data = response.data{
                        if let severError = try? JSONDecoder().decode(RateAndFeedbackErrorResponse.self, from: data){
                            print(severError.detail)
                            completion(false,severError.detail)
                        }
                        else{
                            completion(false,error.localizedDescription)
                        }
                        
                    }
                    else{
                        print("faild to get all categories")
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
    let payload: RatingFeedback
    let statusCode: String
    let timestamp: String
}
