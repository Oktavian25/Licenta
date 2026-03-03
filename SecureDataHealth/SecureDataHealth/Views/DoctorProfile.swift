import SwiftUI

struct DoctorProfileView: View {
    @EnvironmentObject var auth: AuthState

    @State private var isLoading = false
    @State private var errorMessage: String?
    var body: some View {
        VStack {
            Form {
                Section("Complete Profile") {

                }

                Section {
                    Button(isLoading ? "Saving..." : "Save Profile") {

                    }
                    .disabled(isLoading)
                }

                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
                }
            }

            Button("Logout") {
                auth.logout()
            }
            .buttonStyle(.plain)
            .padding(.top, 8)
        }
    }

}

