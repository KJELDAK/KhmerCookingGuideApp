//
//  AuthenticationViewModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 10/12/24.
//

import Alamofire
import SwiftUI

import Alamofire

class AuthenticationViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var isEmailValid: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var accessToken: String?
    @Published var isLoading: Bool = false
    // API call to login the user
    func loginUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = "\(API.baseURL)/auth/login"
        isLoading = true
        // Parameters for the request
        let parameters: [String: String] = [
            "email": email,
            "password": password,
        ]

        // Send the login request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case let .success(authResponse):

                    // MARK: - store user token

                    HeaderToken.shared.token = authResponse.payload.accessToken
//                        HeaderToken.shared.role = authResponse.payload.

                    self.isLoading = false
                    if authResponse.statusCode == "200" {
                        completion(true, "Login Successfully")
                        UserDefaults.standard.set(email, forKey: "userId")
                        UserDefaults.standard.set(password, forKey: "password")
                    } else {
                        completion(false, authResponse.message)
                    }

                case let .failure(error):
                    print("error in login : ", error.localizedDescription)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                            self.isLoading = false
                        } else {
                            if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                                print(severError.message)
                                completion(false, severError.message)
                                self.isLoading = false
                            } else {
                                self.isLoading = false
                                // Fallback to a generic error message
                                completion(false, "email_password_invalid")
                            }
                        }
                    } else {
                        completion(false, "technical_error")
                        self.isLoading = false
                    }
                }
            }
    }

    func CheckEmailExists(email: String, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        let url = "\(API.baseURL)/auth/check-email-exist?email=\(email)"
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: EmailResponse.self) { response in
                switch response.result {
                case let .success(value):
                    self.isLoading = false
                    if value.statusCode == "200" {
                        completion(true, value.message)
                    } else {
                        completion(false, value.message)
                    }
                case let .failure(error):
                    print("error in login : ", error.localizedDescription)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            completion(false, severError.detail)
                            self.isLoading = false
                        } else {
                            if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                                print(severError.message)
                                completion(false, severError.message)
                                self.isLoading = false
                            } else {
                                self.isLoading = false
                                completion(false, "email_not_exist")
                            }
                        }
                    }
                }
            }
    }

    func sendOTP(email: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/auth/send-otp?email=\(email)"
        AF.request(url, method: .post, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: OTPResponse.self) { response in
                switch response.result {
                case let .success(Value):
                    self.isLoading = false
                    completion(true, Value.message)
                case let .failure(error):
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print(severError.payload)
                            completion(false, severError.payload)
                            self.isLoading = false
                        }
                    } else {
                        completion(false, "technical_error")
                        self.isLoading = false
                    }
                }
            }
    }

    func resetPassword(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/auth/reset-password"

        let paramters: [String: Any] = ["email": email, "newPassword": password]
        AF.request(url, method: .post, parameters: paramters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ResponseWrapper<String>.self) { response in
                switch response.result {
                case let .success(Value):
                    self.isLoading = false
                    completion(true, Value.message)
                case let .failure(error):
                    print("error", error.localizedDescription)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(APIErrorResponseInVeryOTP.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                            self.isLoading = false
                        }
                    } else {
                        completion(false, "technical_error")
                        self.isLoading = false
                    }
                }
            }
    }

    func createPassword(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/auth/register"

        let paramters: [String: Any] = ["email": email, "newPassword": password]
        print("parameters", paramters)
        AF.request(url, method: .post, parameters: paramters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: SuccessCreatePasswordResponse.self) { response in
                switch response.result {
                case let .success(Value):

                    // MARK: - store user token

                    HeaderToken.shared.token = Value.payload.accessToken
                    print("success hxx", Value.payload.accessToken)
                    self.isLoading = false
                    completion(true, Value.message)
                case let .failure(error):
                    print("error", error.localizedDescription)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponseInCreatePassword.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                            self.isLoading = false
                        }
                    } else {
                        completion(false, "technical_error")
                        self.isLoading = false
                    }
                }
            }
    }

    func verifyOTP(email: String, otp: String, completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/auth/validate-otp?email=\(email)&otp=\(otp)"
        print(url)
        AF.request(url, method: .post, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ResponseWrapper<VeryEmailPayload>.self) { response in
                switch response.result {
                case let .success(value):
                    self.isLoading = false
                    completion(true, value.message)
                case let .failure(error):
                    print("", error)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(APIErrorResponseInVeryOTP.self, from: data) {
                            print(severError.detail)
                            completion(false, severError.detail)
                        }
                    } else {
                        completion(false, "technical_error")
                        self.isLoading = false
                    }
                }
            }
    }

    func saveUserInfo(userName: String, phoneNumber: String, completion: @escaping (Bool, String) -> Void) {
        let parameters: [String: Any] = ["userName": userName, "phoneNumber": phoneNumber, "address": "null"]
        let url = "\(API.baseURL)/auth/save-user-info"
        print(HeaderToken.shared.headerToken)
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: UserInfoResponse.self) { response in
                switch response.result {
                case let .success(value):

                    self.isLoading = false
                    completion(true, "user_info_saved")
                case let .failure(error):
                    print("", error)
                    if let data = response.data {
                        if let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data) {
                            print(severError.message)
                            completion(false, severError.message)
                        }
                    } else {
                        print("yoo", error.localizedDescription)
                        completion(false, "technical_error")
                        self.isLoading = false
                    }
                }
            }
    }

    func autoLogin(completion: @escaping (Bool, String?) -> Void) {
        if let savedEmail = UserDefaults.standard.string(forKey: "userId"),
           let savedPassword = UserDefaults.standard.string(forKey: "password")
        {
            loginUser(email: savedEmail, password: savedPassword) { success, message in
                completion(success, message)
            }
        } else {
            completion(false, "No saved credentials")
        }
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "password")
        HeaderToken.shared.token = ""
        HeaderToken.shared.role = ""
        isAuthenticated = false
    }
    func isTokenExpired(_ token: String) -> Bool {
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return true } // Invalid token

        let payloadSegment = segments[1]
        var base64 = String(payloadSegment)
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        // Padding
        while base64.count % 4 != 0 {
            base64 += "="
        }

        guard let payloadData = Data(base64Encoded: base64),
              let payloadJson = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let exp = payloadJson["exp"] as? TimeInterval else {
            return true // Invalid payload or no expiry
        }

        let expiryDate = Date(timeIntervalSince1970: exp)
        return Date() >= expiryDate
    }
    func validateLocalToken() {
        let token = HeaderToken.shared.token
        guard !token.isEmpty else {
            logout()
            return
        }

        if isTokenExpired(token) {
            logout()
        } else {
            isAuthenticated = true
        }
    }


}
