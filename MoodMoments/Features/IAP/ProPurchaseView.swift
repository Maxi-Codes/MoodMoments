//  ProPurchaseView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import SwiftUI
import StoreKit

struct ProPurchaseView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = StoreKitManager.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Mood Moments Pro")
                    .font(.largeTitle).bold()
                Text("• Unbegrenzte Aufnahmezeit\n• Erweiterte Statistiken\n• Werbefrei")
                    .multilineTextAlignment(.center)
                if store.products.isEmpty {
                    ProgressView().onAppear { Task { await store.fetchProducts() } }
                } else {
                    ForEach(store.products, id: \.id) { product in
                        Button(action: { Task { await store.buy(product) } }) {
                            Text("Kaufen – \(product.displayPrice)")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("AccentColor"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                if store.purchased {
                    Label("Vielen Dank für deinen Kauf!", systemImage: "checkmark.seal.fill").foregroundColor(.green)
                }
                Spacer()
            }
            .padding()
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Schließen") { dismiss() } } }
        }
    }
}

#Preview {
    ProPurchaseView()
}
