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
    
    func fetchRecipeById(id : Int, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/guest-user/foods/detail/\(id)?itemType=FOOD_RECIPE"
        isLoading = true
        print(url)
        AF.request(url, encoding: JSONEncoding.default/* headers: HeaderToken.shared.headerToken*/)
            .validate()
            .responseDecodable(of: FoodRecipeResponse.self) { response in
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
        let url = "\(API.baseURL)/cuisine/all"
        AF.request(url,encoding: JSONEncoding.default)
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
}


