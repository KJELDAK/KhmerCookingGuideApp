//
//  FileUploader.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 29/4/25.
//

import Alamofire
import Foundation

final class FileUploader {
    static let shared = FileUploader() // Singleton instance
    private init() {} // Prevent external instantiation

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
            case let .success(value):
                print("✅ File uploaded successfully: \(value)")
                self.image = value.payload
                completion(true, "Upload successful")
            case let .failure(error):
                print("❌ File upload failed sdsd: \(error.localizedDescription)")
                completion(false, "Upload failed: \(error.localizedDescription)")
            }
        }
    }
}
