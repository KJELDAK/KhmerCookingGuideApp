//
//  ProfileViewModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import Alamofire
import SwiftUI
class ProfileViewModel: ObservableObject {
    @Published var userInfo: NewUserInfoResponse?
    @Published var isLoading: Bool = false
    @Published var isLoadingWhenUpdate: Bool = false
    func getUserInfo(completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/user/profile"
        isLoading = true
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: NewUserInfoResponse.self) { response in
                switch response.result {
                case let .success(value):
                    self.isLoading = false
                    self.userInfo = value
                    HeaderToken.shared.role = value.payload.role
                    completion(true, "get user info success")
                case let .failure(error):
                    print("", error)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print(severError.message)
                            completion(false, severError.message)
                        }
                    } else {
                        print("yoo", error.localizedDescription)
                        completion(false, error.localizedDescription)
                        self.isLoading = false
                    }
                }
            }
    }

    func updateUserProfile(profileImage: String, fullName: String, phoneNumber: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/user/edit-profile"
        let parameters: [String: Any] = [
            "profileImage": profileImage,
            "fullName": fullName,
            "phoneNumber": phoneNumber,
        ]
        isLoadingWhenUpdate = true
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: UpdateProfileResponse.self) { response in
                switch response.result {
                case let .success(value):
                    completion(true, value.message)
                    self.isLoadingWhenUpdate = false
                case let .failure(error):
                    self.isLoadingWhenUpdate = false

                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(APIErrorResponseInVeryOTP.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                        }
                    } else {
                        print("yoo", error.localizedDescription)
                        completion(false, "Could not update profile,please try again later")
                        self.isLoadingWhenUpdate = false
                    }

                    print(error)
                }
            }
    }
}

import Foundation

struct UpdateProfileResponse: Codable {
    let message: String
    let payload: UserProfile
    let statusCode: String
    let timestamp: String
}

struct UserProfile: Codable {
    let id: Int
    let fullName: String
    let email: String
    let profileImage: String
    let phoneNumber: String
    let password: String
    let role: String
    let createdAt: String
    let emailVerifiedAt: String
    let emailVerified: Bool
    let deleted: Bool
}
