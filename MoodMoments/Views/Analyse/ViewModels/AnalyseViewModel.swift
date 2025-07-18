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
    private var context: ModelContext?

    @Published private(set) var last7Days: [DayStat] = []
    @Published private(set) var last14Days: [DayStat] = []
    @Published private(set) var last30Days: [DayStat] = []

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
        // 7 Tage
        let start7 = calendar.date(byAdding: .day, value: -6, to: today)!
        let request7 = FetchDescriptor<MoodEntry>(predicate: #Predicate { $0.date >= start7 && $0.date <= today })
        // 14 Tage
        let start14 = calendar.date(byAdding: .day, value: -13, to: today)!
        let request14 = FetchDescriptor<MoodEntry>(predicate: #Predicate { $0.date >= start14 && $0.date <= today })
        // 30 Tage
        let start30 = calendar.date(byAdding: .day, value: -29, to: today)!
        let request30 = FetchDescriptor<MoodEntry>(predicate: #Predicate { $0.date >= start30 && $0.date <= today })
        do {
            // 7 Tage
            let entries7 = try context.fetch(request7)
            var grouped7: [Date: [MoodEntry]] = [:]
            for e in entries7 {
                let day = calendar.startOfDay(for: e.date)
                grouped7[day, default: []].append(e)
            }
            last7Days = (0...6).map { offset in
                let day = calendar.date(byAdding: .day, value: -offset, to: today)!
                let list = grouped7[day] ?? []
                let avg = list.isEmpty ? 0 : Double(list.map { $0.mood }.reduce(0, +)) / Double(list.count)
                return DayStat(date: day, averageMood: avg)
            }.reversed()
            // 14 Tage
            let entries14 = try context.fetch(request14)
            var grouped14: [Date: [MoodEntry]] = [:]
            for e in entries14 {
                let day = calendar.startOfDay(for: e.date)
                grouped14[day, default: []].append(e)
            }
            last14Days = (0...13).map { offset in
                let day = calendar.date(byAdding: .day, value: -offset, to: today)!
                let list = grouped14[day] ?? []
                let avg = list.isEmpty ? 0 : Double(list.map { $0.mood }.reduce(0, +)) / Double(list.count)
                return DayStat(date: day, averageMood: avg)
            }.reversed()
            // 30 Tage
            let entries30 = try context.fetch(request30)
            var grouped30: [Date: [MoodEntry]] = [:]
            for e in entries30 {
                let day = calendar.startOfDay(for: e.date)
                grouped30[day, default: []].append(e)
            }
            last30Days = (0...29).map { offset in
                let day = calendar.date(byAdding: .day, value: -offset, to: today)!
                let list = grouped30[day] ?? []
                let avg = list.isEmpty ? 0 : Double(list.map { $0.mood }.reduce(0, +)) / Double(list.count)
                return DayStat(date: day, averageMood: avg)
            }.reversed()
        } catch {
            print("Analyse fetch error: \(error)")
        }
    }
}
