import SwiftUI

struct BlackButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(configuration.isPressed ? 0.5 : 1))
            .foregroundColor(.white)
            .cornerRadius(16)
    }
}
