import SwiftUI

struct LockedChartOverlay: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.fill")
                .font(.title)
                .foregroundColor(.yellow)
            Text("Mit Premium freischalten")
                .font(.headline)
                .foregroundColor(.yellow)
                .shadow(radius: 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.20))
        .cornerRadius(16)
    }
} 