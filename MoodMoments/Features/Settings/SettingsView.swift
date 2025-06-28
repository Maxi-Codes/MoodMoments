//  SettingsView.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Darstellung") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }

                Section("Onboarding") {
                    Button("Onboarding erneut anzeigen") {
                        hasSeenOnboarding = false
                    }
                }

                Section("App") {
                    Button("App bewerten") { rateApp() }
                    Button("Support kontaktieren") { contactSupport() }
                }
            }
            .navigationTitle("Einstellungen")
        }
    }

    // MARK: – Actions
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            #if canImport(StoreKit)
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: scene)
            }
            #endif
        }
    }

    private func contactSupport() {
        let email = "support@moodmoments.app"
        if let url = URL(string: "mailto:\(email)?subject=Support%20Anfrage") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
