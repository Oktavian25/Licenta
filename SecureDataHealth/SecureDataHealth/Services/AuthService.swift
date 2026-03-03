import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int, String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid Response"
        case let .httpError(code, body): return "HTTP \(code): \(body)"
        }
    }
}

final class AuthService{
    static let shared = AuthService()
    private init(){}
    
    private let baseUrl = "http://localhost:5273"
    
    func login(email: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: "\(baseUrl)/login") else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url);
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = LoginRequest(email: email,password: password);
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIError.httpError(http.statusCode, body)
        }
        
        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
    
    func register(email: String,
                  password: String,
                  firstName: String,
                  lastName: String,
                  country: String,
                  role: Int)
    async throws {
        guard let url = URL(string: "\(baseUrl)/auth/register") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = RegisterRequest(email: email,
                                      password: password,
                                      firstName: firstName,
                                      lastName: lastName,
                                      country: country,
                                      Role: role);
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIError.httpError(http.statusCode, body)
        }
    }
    
    func refresh(refreshToken: String) async throws -> RefreshResponse {
        guard let url = URL(string: "\(baseUrl)/refresh") else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url);
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = RefreshRequest(refreshToken: refreshToken)
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIError.httpError(http.statusCode, body)
        }
        
        return try JSONDecoder().decode(RefreshResponse.self, from: data)
    }
}

