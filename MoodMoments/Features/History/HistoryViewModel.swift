//  HistoryViewModel.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
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
    @Published private(set) var groupedEntries: [Date: MoodEntry] = [:]

    // MARK: – Dependencies
    @Environment(\.modelContext) private var context

    private var cancellables = Set<AnyCancellable>()

    init(currentMonth: Date = .now) {
        self.currentMonth = Calendar.current.startOfMonth(for: currentMonth)
        Task { await fetchEntries() }
    }

    func changeMonth(by value: Int) {
        currentMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) ?? currentMonth
        Task { await fetchEntries() }
    }

    // MARK: – Fetch
    private func fetchEntries() async {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: currentMonth) else { return }
        let request = FetchDescriptor<MoodEntry>(predicate: #Predicate { $0.date >= interval.start && $0.date < interval.end })
        do {
            let entries = try context.fetch(request)
            groupedEntries = Dictionary(entries.map { (calendar.startOfDay(for: $0.date), $0) }, uniquingKeysWith: { $1 })
        } catch {
            print("History fetch error: \(error)")
        }
    }
}
