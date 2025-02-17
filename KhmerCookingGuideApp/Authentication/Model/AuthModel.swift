//
//  AuthModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 10/12/24.
//
import Foundation
//MARK: - log in response model
struct AuthResponse: Codable {
    let message: String
    let payload: Payload
    let statusCode: String
    let timestamp: String
    
    struct Payload: Codable {
        let accessToken: String
        let refreshToken: String
        let profileImage: String
        let fullName: String
        let email: String
        let createdDate: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
            case profileImage = "profile_image"
            case fullName = "full_name"
            case email
            case createdDate = "created_date"
        }
    }
}
//MARK: - errror response model
struct ErrorResponse: Codable {
    let type: String
    let title: String
    let status: Int
    let detail: String
    let instance: String
    let time: String
}

struct ErrorResponseInLogin: Codable {
    let message: String
    let payload: String
    let statusCode: String
    let timestamp: String
}
//MARK: - email validation response
struct EmailResponse: Codable {
    let message: String
    let payload: String
    let statusCode: String
    let timestamp: String
}
//MARK: - OTP response
struct OTPResponse: Codable {
    let message: String
    let payload: Payload
    let statusCode: String
    let timestamp: String

    struct Payload: Codable {
        let email: String
        let otp: String
    }
}


struct VeryEmailPayload: Codable {
    let email: String
    let isEmailVerified: Bool
    let verifiedAt: String
}
struct ResetPasswordPayload: Codable {
    let payload: String
}
//MAIN MODEL
struct ResponseWrapper <T: Codable>: Codable {
    let message: String
    let payload: T
    let statusCode: String
    let timestamp: String
}
struct APIErrorResponseInVeryOTP: Decodable {
    let type: String
    let title: String
    let status: Int
    let detail: String
    let instance: String
    let timestamp: String
    let time: String?
}
//Create password
struct UserPayload: Codable {
    let accessToken: String
    let refreshToken: String
    let profileImage: String
    let fullName: String
    let email: String
    let createdDate: Date

    // Coding keys to map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case profileImage = "profile_image"
        case fullName = "full_name"
        case email = "email"
        case createdDate = "created_date"
    }
}
struct ErrorResponseInCreatePassword: Codable {
    let type: String
    let title: String
    let status: String
    let detail: String
    let instance: String
    let timestamp: String

}

struct SuccessCreatePasswordResponse: Codable {
    let message: String
    let payload: Payload
    let statusCode: String
    let timestamp: String

    struct Payload: Codable {
        let accessToken: String
        let refreshToken: String
        let profileImage: String
        let fullName: String
        let email: String
        let createdDate: String

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
            case profileImage = "profile_image"
            case fullName = "full_name"
            case email = "email"
            case createdDate = "created_date"
        }
    }
}

struct UserInfoResponse: Codable {
    let message: String
    let payload: Payload
    let statusCode: String
    let timestamp: String

    struct Payload: Codable {
        let email: String
        let fullName: String
        let phoneNumber: String
//        let address: String
    }
}
