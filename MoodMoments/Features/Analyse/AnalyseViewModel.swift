//  AnalyseViewModel.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import Foundation
import SwiftData
import StoreKit
import SwiftUICore

@MainActor
final class AnalyseViewModel: ObservableObject {
    struct DayStat: Identifiable {
        let id = UUID()
        let date: Date
        let averageMood: Double
    }

    private var context: ModelContext?

    @Published private(set) var last7Days: [DayStat] = []

    // Neue Funktion um context zu setzen
    func setContext(_ context: ModelContext) {
        self.context = context
    }

    func fetch() {
        guard let context = context else {
            return
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.date(byAdding: .day, value: -6, to: today)!
        let request = FetchDescriptor<MoodEntry>(predicate: #Predicate { $0.date >= start && $0.date <= today })

        do {
            let entries = try context.fetch(request)
            var grouped: [Date: [MoodEntry]] = [:]
            for e in entries {
                let day = calendar.startOfDay(for: e.date)
                grouped[day, default: []].append(e)
            }

            last7Days = (0...6).map { offset in
                let day = calendar.date(byAdding: .day, value: -offset, to: today)!
                let list = grouped[day] ?? []
                let avg = list.isEmpty ? 0 : Double(list.map { $0.mood }.reduce(0, +)) / Double(list.count)
                return DayStat(date: day, averageMood: avg)
            }.reversed()
        } catch {
            print("Analyse fetch error: \(error)")
        }
    }
}
