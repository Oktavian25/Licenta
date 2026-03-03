import SwiftUI

@main
struct SecureDataHealthApp: App {
    @StateObject private var auth = AuthState()
    
    var body: some Scene {
        WindowGroup {
            PatientProfileView().environmentObject(auth)
        }
    }
}
