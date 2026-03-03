import Foundation
import Security

enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
}

class KeychainService {
    static func save(value: String, service: String, account: String) throws {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: value
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil);
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry;
        }
    
        guard status != errSecSuccess else {
            throw KeychainError.unknown(status);
        }
    }
    
    static func read(service: String, account: String) -> Data? {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        SecItemCopyMatching(query as CFDictionary, &result)
        
        return result as? Data;
    }
    
    static func delete(service: String, account: String){
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        SecItemDelete(query as CFDictionary);
    }
}
    
