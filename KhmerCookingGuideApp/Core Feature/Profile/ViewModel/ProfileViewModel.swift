//
//  ProfileViewModel.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import SwiftUI
import Alamofire
class ProfileViewModel: ObservableObject {
    @Published var userInfo: NewUserInfoResponse?
    @Published var isLoading: Bool = false
    func getUserInfo(completion: @escaping(Bool, String) -> Void) {
        let url = "\(API.baseURL)/user/profile"
        AF.request(url,method: .get, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
            .validate()
            .responseDecodable(of: NewUserInfoResponse.self) { response in
                switch response.result {
                case .success(let value):
                    self.isLoading = false
                    self.userInfo = value
                    HeaderToken.shared.role = value.payload.role
                    completion(true, "get user info success")
                case .failure(let error):
                    print("",error)
                    if let data = response.data{
                       if  let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data){
                           print(severError.message)
                           completion(false,severError.message)
                        }
                    }
                    else{
                        print("yoo",  error.localizedDescription)
                        completion(false, error.localizedDescription)
                        self.isLoading = false
                    }
                    
                    
                }
            }
    }
}
//func saveUserInfo(userName: String, dateOfBirth: String, gender: String, completion: @escaping(Bool, String) -> Void){
//    let parameters: [String: Any] = ["userName": userName,"phoneNumber": gender, "address": dateOfBirth]
//    let url = "\(API.baseURL)/auth/save-user-info"
//    print(HeaderToken.shared.headerToken)
//    AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HeaderToken.shared.headerToken)
//        .validate()
//        .responseDecodable(of: UserInfoResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//                print("fghj",value.message)
//                self.isLoading = false
//                completion(true, value.message)
//            case .failure(let error):
//                print("",error)
//                if let data = response.data{
//                   if  let severError = try? JSONDecoder().decode(ErrorResponseInLogin.self, from: data){
//                       print(severError.message)
//                       completion(false,severError.message)
//                    }
//                }
//                else{
//                    print("yoo",  error.localizedDescription)
//                    completion(false, error.localizedDescription)
//                    self.isLoading = false
//                }
//                
//            }
//            
//        }
//}
