//  MoodEntry.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import Foundation
import SwiftData
import SwiftUICore

/// Persistentes Datenmodell für einen Stimmungseintrag
@Model
final class MoodEntry {
    var id: UUID
    var mood: Int
    var date: Date
    var audioFilePath: String?
    var audioLenght: Int?
    var transcript: String?

    init(mood: Int, date: Date = .now, audioFilePath: String? = nil, audioLenght: Int? = nil, transcript: String? = nil) {
        self.id = UUID()
        self.mood = mood
        self.date = date
        self.audioFilePath = audioFilePath
        self.audioLenght = audioLenght
        self.transcript = transcript
    }

    // MARK: – Convenience
    var smiley: String {
        switch mood {
        case 1: return "circle.fill"
            case 2: return "circle.fill"
            case 3: return "circle.fill"
            case 4: return "circle.fill"
            case 5: return "circle.fill"
            default: return "questionmark"
        }
    }
    
    var smileyColor: Color {
        switch mood {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green.opacity(0.7)
        case 5: return .green
        default: return .gray
        }
    }

    var moodLabel: String {
        switch mood {
        case 1: return "Sehr schlecht"
        case 2: return "Schlecht"
        case 3: return "Neutral"
        case 4: return "Gut"
        case 5: return "Sehr gut"
        default: return "Unbekannt"
        }
    }
}
