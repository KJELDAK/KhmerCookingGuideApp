//
//  ProfileModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import Foundation
import Foundation

// Root Model
struct NewUserInfoResponse: Codable {
    let message: String
    let payload: NewUserPayload
    let statusCode: String
    let timestamp: String
}

// Payload Model
struct NewUserPayload: Codable {
    let id: Int
    let fullName: String
    let email: String
    let profileImage: String
    let phoneNumber: String
    let password: String
    let role: String
    let createdAt: String
    let emailVerifiedAt: String?
    let emailVerified: Bool
}
