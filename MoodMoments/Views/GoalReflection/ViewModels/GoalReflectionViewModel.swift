//
//  GoalReflectionViewModel.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 23.07.25.
//

import Foundation
import Combine
import SwiftData
import SwiftUICore

@MainActor
final class GoalReflectionViewModel: ObservableObject {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    public func saveGoal(goal: String, description: String) {
        let currentDateTime = Date()
        let entry = GoalEntry(goal: goal, description: description, date: currentDateTime)
        context.insert(entry)
        try? context.save()
    }
    
}
