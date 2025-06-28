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
    var body: some Scene {
        WindowGroup {
            RootContentView()
        }
        .modelContainer(for: MoodEntry.self)
    }
}
