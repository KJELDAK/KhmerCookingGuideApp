//
//  HomeViewModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 24/12/24.
//

import Alamofire
import Foundation

class HomeViewModel: ObservableObject {
    @Published var categories: [CategoryResponsePayload] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var foodRecipes: [FoodRecipe] = []
    @Published var popularRecipes: [PopularRecipe] = []
    @Published var RecipeInCategory: [FoodRecipeInCategory] = []

    func getAllCategories(completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/category/all"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: ResponseWrapper<[CategoryResponsePayload]>.self) { response in
                switch response.result {
                case let .success(value):
                    self.categories = value.payload
                    self.isLoading = false
                    completion(true, value.message)
                case let .failure(error):
                    print("error fectch all categories", error)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                        }
                        self.isLoading = false
                    } else {
                        print("faild to get all categories")
                        completion(false, error.localizedDescription)
                        self.isLoading = false
                    }
                }
            }
    }

    func getAllFoodRecipes(completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        let url = "\(API.baseURL)/food-recipe/list"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: FoodRecipesResponse.self) { response in
                switch response.result {
                case let .success(value):

                    self.foodRecipes = value.payload
                    completion(true, value.message)
                    self.isLoading = false
                case let .failure(error):
                    print("errpr", error)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print(severError.payload)
                        }
                        self.isLoading = false
                    } else {
                        print("faild to get all categories")
                        completion(false, error.localizedDescription)
                        self.isLoading = false
                    }
                }
            }
    }

    func getPopularFoods(completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/guest-user/foods/popular"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: PopularFoodResponse.self) { response in
                switch response.result {
                case let .success(value):
                    self.popularRecipes = value.payload.popularRecipes
                    completion(true, value.message)
//                    print("this is food recipes\(self.foodRecipes)")
                case let .failure(error):
                    print("cant get popular foods", error)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print(severError.payload)
                        }
                        self.isLoading = false
                    } else {
                        print("faild to get all categories")
                        completion(false, error.localizedDescription)
                        self.isLoading = false
                    }
                }
            }
    }

    func getFoodByCategoryId(id: Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/foods/\(id)"
        print("this is url", url)
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: FoodResponse.self) { response in
                switch response.result {
                case let .success(value):
                    self.RecipeInCategory = value.payload.foodRecipes
                    completion(true, value.message)
//                    print("this is food recipes\( self.RecipeInCategory)")
                case let .failure(error):
                    print("error get food by category", error)
                    if let data = response.data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            
                        }

                        if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print(severError.payload)
                        }
                        self.isLoading = false
                    } else {
                        print("faild to get all categories")
                        completion(false, error.localizedDescription)
                        self.isLoading = false
                    }
                }
            }
    }
}
