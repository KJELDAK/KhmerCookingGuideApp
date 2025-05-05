//
//  PostFoodRecipeViewModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 16/1/25.
//
import Alamofire
import SwiftUI

class PostFoodRecipeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: [String] = []
    func uploadFiles(imageDataArray: [Data], completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/fileView/file"
        isLoading = true

        AF.upload(
            multipartFormData: { multipartFormData in
                for (index, imageData) in imageDataArray.enumerated() {
                    multipartFormData.append(
                        imageData,
                        withName: "files", // Key for your backend
                        fileName: "image\(index).jpeg",
                        mimeType: "image/jpeg"
                    )
                }
            },
            to: url,
            method: .post
//            headers: HeaderToken.shared.headerToken
        )

        .responseDecodable(of: UploadFileResponse.self) { response in
            switch response.result {
            case let .success(value):
                print("✅ File uploaded successfully: \(value)")
                self.image = value.payload
                completion(true, "Upload successful")
            case let .failure(error):
                self.isLoading = false
                print("❌ File upload failed: \(error.localizedDescription)")
                completion(false, "Upload failed: \(error.localizedDescription)")
            }
        }
    }

    func postFoodRecipe(_ foodRecipe: PostFoodRequest, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        let url = "\(API.baseURL)/food-recipe/post-food-recipe" // Replace with your actual API endpoint

        AF.request(url,
                   method: .post,
                   parameters: foodRecipe,
                   encoder: JSONParameterEncoder.default,
                   headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: PostFoodResponse.self) { response in
                self.isLoading = false
                switch response.result {
                case let .success(value):
                    print("✅ Food recipe posted successfully: \(value)")
                    completion(true, "food_recipe_posted_successfully")

                case let .failure(error):
                    print("❌ Error posting food recipe:", error)

                    if let data = response.data {
                        if let serverError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print("Server Error:", serverError.payload)
                        }
                    }
                    completion(false, "technical_error")
                }
            }
    }

    func updateFoodRecipeById(id: Int, _ foodRecipe: PostFoodRequest, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        let url = "\(API.baseURL)/food-recipe/edit-food-recipe/\(id)" // Replace with your actual API endpoint

        AF.request(url,
                   method: .put,
                   parameters: foodRecipe,
                   encoder: JSONParameterEncoder.default,
                   headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: PostFoodResponse.self) { response in
                self.isLoading = false
                switch response.result {
                case let .success(value):
                    print(value.message)
                    completion(true, value.message)

                case let .failure(error):
                    print("❌ Error editing food recipe:", error)

                    if let data = response.data {
                        if let serverError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print("Server Error:", serverError.payload)
                        }
                    }
                    completion(false, "technical_error")
                }
            }
    }
}
