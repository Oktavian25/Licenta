import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthState
    
    var body: some View {
        Group {
            if auth.isAuthenticated {
                HomeView()
            }
            else {
                AuthView()
            }
        }.onAppear {
            auth.refreshState()
        }
    }
}
