import SwiftUI

struct OnboardPage: View {
    let image: String
    let title: String
    let subtitle: String
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("AccentColor"))
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text(subtitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
} 