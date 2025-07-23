//
//  MoodMomentsApp.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import SwiftUI
import SwiftData

@main
struct MoodMomentsApp: App {
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"

    
    init() {
            NotificationManager.shared.requestPermission()
            NotificationManager.shared.scheduleDailyReminder()
        }
    
    var body: some Scene {
        WindowGroup {
            RootContentView()
                .preferredColorScheme(preferredScheme)
            }
        .modelContainer(for: [MoodEntry.self, GoalEntry.self, ReflectionEntry.self])
    }
    
    private var preferredScheme: ColorScheme? {
        switch selectedAppearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil // folgt System
        }
    }
}
