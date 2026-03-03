import SwiftUI

struct LoginView : View {
    @State private var email =  ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @EnvironmentObject var auth: AuthState
    let onRegisterTap: () -> Void
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $password)
                }
                Section {
                    Button(isLoading ? "Logging in..." : "Login"){
                        Task { await loginHandler() }
                    }
                    .buttonStyle(BlackButtonStyle())
                    .disabled(isLoading)
                }
                Button("Create account") {
                    onRegisterTap()
                }.disabled(isLoading)
            }
            .navigationTitle("Login")
            .contentMargins(.vertical, 10)
            .scrollDisabled(true)
            
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }
        }
    }
    
    private func loginHandler() async {
        isLoading = true
        errorMessage = nil
        do {
            try await auth.doLogin(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
