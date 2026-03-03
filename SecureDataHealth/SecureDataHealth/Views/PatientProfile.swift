import SwiftUI

struct PatientProfileView: View {
    @EnvironmentObject var auth: AuthState

    @State private var phoneNumber = ""
    @State private var gender: Gender = .Male
    @State private var dateOfBirth = Date()

    @State private var isLoading = false
    @State private var errorMessage: String?
    var body: some View {
        VStack {
            Form {
                Section("Complete Profile") {
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases, id: \.self) { r in
                            Text(String(describing: r).capitalized).tag(r)
                        }
                    }
                    TextField("Phone Number", text: $phoneNumber)
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
