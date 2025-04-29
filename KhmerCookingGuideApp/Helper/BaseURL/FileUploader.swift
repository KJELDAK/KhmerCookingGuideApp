//
//  FileUploader.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 29/4/25.
//


import Foundation
import Alamofire

final class FileUploader {
    
    static let shared = FileUploader()  // Singleton instance
    private init() {}                   // Prevent external instantiation
    
    var isLoading = false
    var image: [String] = []

    func uploadFiles(imageDataArray: [Data], completion: @escaping (Bool, String) -> Void) {
        let url = "\(API.baseURL)/fileView/file"
        isLoading = true

        AF.upload(
            multipartFormData: { multipartFormData in
                for (index, imageData) in imageDataArray.enumerated() {
                    multipartFormData.append(
                        imageData,
                        withName: "files", // Backend key
                        fileName: "image\(index).jpeg",
                        mimeType: "image/jpeg"
                    )
                }
            },
            to: url,
            method: .post
//          headers: HeaderToken.shared.headerToken
        )
        .responseDecodable(of: UploadFileResponse.self) { response in
            self.isLoading = false
            switch response.result {
            case .success(let value):
                print("✅ File uploaded successfully: \(value)")
                self.image = value.payload
                completion(true, "Upload successful")
            case .failure(let error):
                print("❌ File upload failed: \(error.localizedDescription)")
                completion(false, "Upload failed: \(error.localizedDescription)")
            }
        }
    }
}
