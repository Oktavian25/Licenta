import SwiftUI

struct RegisterView : View {
    @State private var firstName =  ""
    @State private var lastName = ""
    @State private var email =  ""
    @State private var password = ""
    @State private var country = "Romania"
    @State private var role: UserRole = .patient
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @EnvironmentObject var auth: AuthState
    
    let onLoginTap: () -> Void

    let countries = [
        "Argentina", "Australia", "Austria", "Belgium", "Brazil", "Bulgaria", "Canada", "China", "Croatia", "Czechia", "Denmark", "Egypt", "Finland", "France", "Germany", "Greece", "Hungary", "India", "Ireland", "Israel", "Italy", "Japan", "Mexico", "Netherlands", "New Zealand", "Norway", "Poland", "Portugal", "Romania", "Saudi Arabia", "Serbia", "Slovakia", "Slovenia", "South Africa", "South Korea", "Spain", "Sweden", "Switzerland", "Turkey", "UAE", "Ukraine", "United Kingdom", "United States"
    ]
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("First Name", text: $firstName)
                        .autocorrectionDisabled()
                    
                    TextField("Last Name", text: $lastName)
                        .autocorrectionDisabled()
                }
                Section {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $password)
                    
                    Picker("Country", selection: $country){
                        ForEach(countries, id: \.self) {
                            country in Text(country)
                        }
                    }
                    
                    Picker("Role", selection: $role) {
                        ForEach(UserRole.allCases, id: \.self) { r in
                            Text(String(describing: r).capitalized).tag(r)
                        }
                    }
                }
                Section {
                    Button(isLoading ? "..." : "Register"){
                        Task { await registerHandler() }
                    }
                    .buttonStyle(BlackButtonStyle())
                    .disabled(isLoading)
                }
                Button("Already have an account") {
                    onLoginTap()
                }.disabled(isLoading)
            }
            .navigationTitle("Register")
            .contentMargins(.vertical, 10)
            .scrollDisabled(true)
        }
        
        if let errorMessage {
            Text(errorMessage).foregroundStyle(.red)
        }
    }
    
    private func registerHandler() async {
        isLoading = true
        errorMessage = nil
        do {
            try await AuthService.shared.register(email: email,
                                                  password: password,
                                                  firstName: firstName,
                                                  lastName: lastName,
                                                  country: country,
                                                  role: role.rawValue)
            
            try await auth.doLogin(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
