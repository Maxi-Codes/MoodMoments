//
//  ReflectionEntry.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 23.07.25.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
final class ReflectionEntry {
    var id = UUID()
    var text: String
    var date: Date
    
    init(text: String, date: Date = .now) {
        self.id = UUID()
        self.text = text
        self.date = date
    }
    
}
