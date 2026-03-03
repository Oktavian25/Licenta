import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let tokenType: String
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let country: String
    let Role: Int       
}

struct RefreshRequest: Codable {
    let refreshToken: String
}

struct RefreshResponse: Codable {
    let tokenType: String
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
}

