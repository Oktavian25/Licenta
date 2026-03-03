import SwiftUI

struct AuthView: View {
    @State private var screen: AuthScreen = .login

    var body: some View {
        switch screen {
        case .login:
            LoginView(
                onRegisterTap: { screen = .register }
            )
        case .register:
            RegisterView(
                onLoginTap: { screen = .login }
            )
        case .doctorProfile:
            DoctorProfileView() // remove later

        case .patientProfile:
            PatientProfileView()

        case .home:
            HomeView()
        }
    }
}
