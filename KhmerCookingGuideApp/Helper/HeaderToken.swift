import Foundation
import Alamofire

class HeaderToken: ObservableObject {
    // MARK: - Singleton instance for global access
    static let shared = HeaderToken()
    
    // MARK: - Properties for storing user token
    @Published var token: String {
        didSet {
            // Update the headers whenever the token changes
            headerToken["Authorization"] = "Bearer \(token)"
            
            // Save the token to UserDefaults for persistence
            UserDefaults.standard.set(token, forKey: "userToken")
            
            print("Updated User Token: \(token)")
        }
    }
    //MARK: - Properties for storing user's role
    @Published var role: String{
        didSet{
            UserDefaults.standard.set(role, forKey: "userRole")
        }
    }
    
    // MARK: - HTTP headers including the authorization token
    @Published var headerToken: HTTPHeaders = [
        "Accept": "*/*",
        "Authorization": "Bearer ",
        "Content-Type": "application/json"
    ]
    
    // MARK: - Private initializer to enforce singleton pattern
    private init() {
        // Retrieve the token from UserDefaults when initializing
        self.token = UserDefaults.standard.string(forKey: "userToken") ?? ""
        self.role = UserDefaults.standard.string(forKey: "userRole") ?? ""
        // Update the Authorization header with the saved token
        headerToken["Authorization"] = "Bearer \(token)"
    }
    
    // MARK: - Method to clear token
    func clearToken() {
        // Clear the token
        token = ""
        
        // Remove token from UserDefaults
        UserDefaults.standard.removeObject(forKey: "userToken")
        
        print("User Token Cleared")
    }
}
