//
//  GoalEntry.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 23.07.25.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
final class GoalEntry {
    var id: UUID
    var goal: String
    var desc: String
    var date: Date
    var isCompleted: Bool = false

    init(goal: String, description: String, date: Date = .now) {
        self.id = UUID()
        self.goal = goal
        self.desc = description
        self.date = date
    }
}
