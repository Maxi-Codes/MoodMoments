import SwiftUI

struct ImpulseView: View {
    let text: String
    let icon: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .italic()
                .font(.subheadline)
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
} 