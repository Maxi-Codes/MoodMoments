//  MoodEntry.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import Foundation
import SwiftData
import SwiftUICore

/// Persistentes Datenmodell für einen Stimmungseintrag
@Model
final class MoodEntry {
    var id: UUID
    var mood: Int          // 1–5
    var date: Date
    var audioFilePath: String?
    var audioLenght: Int?

    init(mood: Int, date: Date = .now, audioFilePath: String? = nil, audioLenght: Int? = nil) {
        self.id = UUID()
        self.mood = mood
        self.date = date
        self.audioFilePath = audioFilePath
        self.audioLenght = audioLenght
    }

    // MARK: – Convenience
    var smiley: String {
        switch mood {
        case 1: return "face.smiling.inverse"                    // traurig
            case 2: return "face.smiling.inverse"           // bisschen traurig
            case 3: return "face.smiling.inverse"       // neutral
            case 4: return "face.smiling.inverse"                   // bisschen fröhlich
            case 5: return "face.smiling.inverse"              // fröhlich
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
