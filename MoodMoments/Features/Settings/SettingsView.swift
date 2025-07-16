//  SettingsView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import SwiftUI
import StoreKit
import SwiftData

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showDeleteAlert = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Form {
                Section("Darstellung") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section("Moods") {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Text("Alle Moods zurücksetzen")
                    }
                }

                Section("App") {
                    Button("App bewerten") { rateApp() }
                    Button("Support kontaktieren") { contactSupport() }
                }
            }
            .navigationTitle("Einstellungen")
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Alle Einträge löschen?"),
                message: Text("Willst du wirklich alle deine Moods unwiderruflich löschen? Diese Aktion kann nicht rückgängig gemacht werden."),
                primaryButton: .destructive(Text("Löschen")) {
                    deleteAllMoods()
                },
                secondaryButton: .cancel()
            )
        }
    }

    // MARK: – Actions
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            #if canImport(StoreKit)
            if #available(iOS 14.0, *) {
                //SKStoreReviewController.requestReview(in: scene)
                AppStore.requestReview(in: scene)
            }
            #endif
        }
    }

    private func contactSupport() {
        let email = "ghostmaxi296@gmail.com"
        if let url = URL(string: "mailto:\(email)?subject=Support%20Anfrage") {
            UIApplication.shared.open(url)
        }
    }

    private func deleteAllMoods() {
        let fetch = FetchDescriptor<MoodEntry>()
        if let moods = try? modelContext.fetch(fetch) {
            for mood in moods {
                modelContext.delete(mood)
            }
        }
        try? modelContext.save()
    }
}

#Preview {
    SettingsView()
}
