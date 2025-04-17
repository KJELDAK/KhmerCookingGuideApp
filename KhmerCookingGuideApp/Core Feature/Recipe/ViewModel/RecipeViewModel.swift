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
    func fetchRecipeById(id : Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/guest-user/foods/detail/\(id)?itemType=FOOD_RECIPE"
        isLoading = true
        print(url)
        AF.request(url, encoding: JSONEncoding.default/* headers: HeaderToken.shared.headerToken*/)
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
    func postRateAndFeedback(foodId: Int, ratingValue: String, commentText: String, completion: @escaping (Bool, String) -> Void){
        let url = ("\(API.baseURL)/feedback?itemType=FOOD_RECIPE")
        self.isLoading = true
        
        let parameter: [String: Any] = [
            "foodId": foodId,
            "ratingValue": ratingValue,
            "commentText": commentText,
        ]
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate()
            .responseDecodable(of: FeedbackResponse.self){ response in
                switch response.result{
                case .success(let value):
                    completion(true, value.message)
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
}


