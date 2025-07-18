//  HistoryViewModel.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import Foundation
import SwiftData
import Combine
import StoreKit
import SwiftUICore

@MainActor
final class HistoryViewModel: ObservableObject {
    // MARK: – Published
    @Published var currentMonth: Date
    @Published private(set) var groupedEntries: [Date: [MoodEntry]] = [:]
    

    // MARK: – Dependencies
    private let context: ModelContext
    
    @Published var streak: Int = 0


    private var cancellables = Set<AnyCancellable>()

    init(context: ModelContext, currentMonth: Date = .now) {
        self.context = context
        self.currentMonth = Calendar.current.startOfMonth(for: currentMonth)
        Task { await fetchEntries() }
    }

    func changeMonth(by value: Int) {
        currentMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) ?? currentMonth
        Task { await fetchEntries() }
    }

    // MARK: – Fetch
    func fetchEntries() async {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: currentMonth) else { return }
        let request = FetchDescriptor<MoodEntry>(predicate: #Predicate { $0.date >= interval.start && $0.date < interval.end })
        do {
            let entries = try context.fetch(request)
            groupedEntries = Dictionary(grouping: entries, by: { calendar.startOfDay(for: $0.date) })
            updateStreak(with: entries)
        } catch {
            print("History fetch error: \(error)")
        }
    }
    
    public func formatDate(date: Date) -> String {
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "dd.MM.yyyy"
        let customString = customFormatter.string(for: date)
        return customString!;
    }
    
    func calculateStreak(from entries: [MoodEntry]) -> Int {
        let calendar = Calendar.current
        let sortedDates = Set(entries.map { calendar.startOfDay(for: $0.date) }) // Nur das Datum (ohne Uhrzeit)
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date()) // heute
        
        while sortedDates.contains(currentDate) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previousDay
        }
        
        return streak
    }
    
    func updateStreak(with entries: [MoodEntry]) {
        streak = calculateStreak(from: entries)
    }
    
    func smileyColor(for mood: Int) -> Color { MoodEntry(mood: mood).smileyColor }
}
