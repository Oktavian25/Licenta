import Foundation
import Combine

@MainActor
final class AuthState: ObservableObject {
    @Published var isAuthenticated = false

    func refreshState() {
        let token = KeychainService.read(service: "SecureDataHealth",account: "AccessToken")
        
        if token != nil {
            isAuthenticated = true
        }
    }
    
    func isAccessTokenExpiringSoon() -> Bool {
        guard
            let rawData = KeychainService.read(
                service: "SecureDataHealth",
                account: "AccessTokenExpiresAt"
            ),
            let expiryTime = String(data: rawData, encoding: .utf8),
            let expiresAt = TimeInterval(expiryTime)
        else {
            return true
        }

        return Date().timeIntervalSince1970 + 60 >= expiresAt
    }

    
    func doLogin(email: String, password: String) async throws {
        let res: LoginResponse = try await AuthService.shared.login(email: email,
                                                                    password: password)
        
        let expiresAt = Date().addingTimeInterval(TimeInterval(res.expiresIn))

        try KeychainService.save(value: res.accessToken,
                                 service: "SecureDataHealth",
                                 account: "AccessToken")
        
        try KeychainService.save(value: res.refreshToken,
                                 service: "SecureDataHealth",
                                 account: "RefreshToken")
        
        try KeychainService.save(value: String(expiresAt.timeIntervalSince1970),
                                 service: "SecureDataHealth",
                                 account: "AccessTokenExpiresAt")
        
        isAuthenticated = true
    }
    
    func logout() {
        KeychainService.delete(service: "SecureDataHealth", account: "AccessToken")
        KeychainService.delete(service: "SecureDataHealth", account: "RefreshToken")
        KeychainService.delete(service: "SecureDataHealth", account: "AccessTokenExpiresAt")
        isAuthenticated = false
    }
}

