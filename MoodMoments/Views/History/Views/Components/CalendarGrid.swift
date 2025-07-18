import SwiftUI

struct CalendarGrid: View {
    let currentMonth: Date
    let entries: [Date: [MoodEntry]]
    let onSelect: (Date, [MoodEntry]) -> Void

    private var days: [Date] {
        Calendar.current.daysInMonth(for: currentMonth)
    }

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let calendar = Calendar(identifier: .gregorian)
    private let today = Calendar.current.startOfDay(for: Date())
    private let weekdaySymbols: [String] = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "de_DE")
        return df.shortWeekdaySymbols
    }()

    var body: some View {
        VStack(spacing: 8) {
            weekdaysHeader
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(days, id: \.self) { date in
                    let dayNumber = calendar.component(.day, from: date)
                    let dayEntries = entries[date] ?? []
                    let hasEntry = !dayEntries.isEmpty
                    let isToday = calendar.isDate(date, inSameDayAs: today)
                    Button(action: { onSelect(date, dayEntries) }) {
                        ZStack {
                            Circle()
                                .fill(hasEntry ? Color.green : Color.gray.opacity(0.1))
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Circle()
                                        .stroke(isToday ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            Text("\(dayNumber)")
                                .font(.caption2)
                                .foregroundColor(hasEntry ? .white : .primary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var weekdaysHeader: some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { day in
                Text(day.prefix(2))
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
        }
    }
} 