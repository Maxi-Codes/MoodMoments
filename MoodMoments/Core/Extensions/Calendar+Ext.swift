//  Calendar+Ext.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import Foundation

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        dateInterval(of: .month, for: date)!.start
    }

    func daysInMonth(for date: Date) -> [Date] {
        guard let interval = dateInterval(of: .month, for: date) else { return [] }
        var days: [Date] = []
        var current = interval.start
        while current < interval.end {
            days.append(current)
            current = self.date(byAdding: .day, value: 1, to: current)!
        }
        return days
    }
}
