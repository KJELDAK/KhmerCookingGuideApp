//
//  FavoriteViewModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 7/4/25.
//

// MARK: - the function in this should be improve

import Alamofire
import Foundation

class FavoriteViewModel: ObservableObject {
    @Published var favoriteList: [FavoriteFoodRecipe] = []
    @Published var isLoading: Bool = false

    func getAllFavoriteFoodRecipes(completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        let url = "\(API.baseURL)/favorite/all"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken).validate().responseDecodable(of: FavoriteFoodsResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                self.favoriteList = data.payload.favoriteFoodRecipes
                completion(true, data.message)
            case let .failure(error):
                self.isLoading = false
                if let data = response.data {
//                    print(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
                    if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                        print(severError.payload)
                        completion(false, severError.payload)
                    } else {
                        completion(false, error.localizedDescription)
                    }
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }

    func addToFavorite(foodId: Int, itemType: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/favorite/add-favorite"
        let parameters: Parameters = [
            "foodId": foodId,
            "itemType": itemType,
        ]
        print("add to favorite parameters\(parameters)")
        isLoading = true
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: HeaderToken.shared.headerToken)
            .validate(statusCode: 200 ..< 500)
            .responseDecodable(of: AddFavoriteResponse.self) { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                switch response.result {
                case let .success(data):
                    completion(true, data.message)
                case let .failure(error):
                    print("Add favorite failed:", error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
            }
    }

    func removeFavorite(foodId: Int, itemType: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/favorite/remove-favorite"
        let parameters: Parameters = [
            "foodId": foodId,
            "itemType": itemType,
        ]
        print("remove to favorite parameters\(parameters)")
        isLoading = true
        AF.request(url, method: .delete, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: HeaderToken.shared.headerToken)
            .validate(statusCode: 200 ..< 500) // Include 400 range so we can parse custom error messages
            .responseDecodable(of: AddFavoriteResponse.self) { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false

                switch response.result {
                case let .success(data):
                    if response.response?.statusCode == 200 {
                        print("✅ Removed favorite: \(data.message)")
                        completion(true, data.message)
                    } else {
                        print("⚠️ Server message: \(data.message)")
                        completion(false, data.message)
                    }
                case let .failure(error):
                    print("❌ Remove favorite failed:", error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
            }
    }
}

struct AddFavoriteResponse: Codable {
    let message: String
    let payload: String
    let statusCode: String
    let timestamp: String
}
