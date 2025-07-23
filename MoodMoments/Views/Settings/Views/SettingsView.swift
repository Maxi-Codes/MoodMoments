//  SettingsView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import SwiftUI
import StoreKit
import SwiftData

struct SettingsView: View {
    @Environment(\.colorScheme) private var systemColorScheme
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showDeleteAlert = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Form {
                SettingsSection(title: "Darstellung") {
                    Picker("Darstellung", selection: $selectedAppearance) {
                        Text("System").tag("system")
                        Text("Hell").tag("light")
                        Text("Dunkel").tag("dark")
                    }
                    .pickerStyle(.segmented)
                }
                
                
                SettingsSection(title: "Moods") {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Text("Alle Moods zurücksetzen")
                    }
                }

                SettingsSection(title: "App") {
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
    
    private var isDarkModeEnabled: Bool {
        switch selectedAppearance {
        case "dark": return true
        case "light": return false
        default: return systemColorScheme == .dark
        }
    }
}

#Preview {
    SettingsView()
}
