//
//  HistoryView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import SwiftUI
import SwiftData

struct IdentifiableDate: Identifiable {
    let id: Date
}

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @StateObject private var audioManager = AudioPlayerManager()

    @State private var selectedDay: IdentifiableDate?
    @Query private var moods: [MoodEntry]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Streak Header
                HStack(spacing: 8) {
                    Text("Deine Streak:")
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(viewModel.streak)")
                }
                .font(.title3)
                .padding(.top)

                // MARK: - Calendar Box
                VStack(spacing: 16) {
                    calendarHeader
                    CalendarGrid(
                        currentMonth: viewModel.currentMonth,
                        entries: viewModel.groupedEntries
                    ) { date in
                        selectedDay = IdentifiableDate(id: date)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .sheet(item: $selectedDay) { wrapper in
                    HistoryDetailView(date: wrapper.id, entry: viewModel.groupedEntries[wrapper.id])
                }

                // MARK: - Last 3 Days Box
                VStack(alignment: .leading, spacing: 16) {
                    Text("Das war die Stimmung der letzten 3 Tage:")
                        .font(.title2)
                        .fontWeight(.bold)

                    VStack(spacing: 12) {
                        ForEach(moods.prefix(3).reversed()) { mood in
                            MoodRow(
                                mood: mood,
                                dateText: viewModel.formatDate(date: mood.date),
                                onPlay: {
                                    audioManager.play(path: mood.audioFilePath ?? "")
                                }
                            )
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal)

                Spacer(minLength: 40)
            }
        }
    }

    // MARK: - Calendar Header
    private var calendarHeader: some View {
        HStack {
            Button(action: { viewModel.changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(viewModel.currentMonth, formatter: DateFormatter.monthAndYear)
                .font(.headline)
            Spacer()
            Button(action: { viewModel.changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
            }
        }
    }
}

// MARK: - Mood Row

struct MoodRow: View {
    let mood: MoodEntry
    let dateText: String
    let onPlay: () -> Void

    var body: some View {
        HStack {
            Image(systemName: mood.smiley)
                .foregroundColor(.orange)

            Text("\(dateText) - \(mood.moodLabel)")
                .font(.subheadline)

            Spacer()

            Button(action: onPlay) {
                Image(systemName: "play.fill")
                    .foregroundColor(Color("AccentColor"))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Calendar Grid

private struct CalendarGrid: View {
    let currentMonth: Date
    let entries: [Date: MoodEntry]
    let onSelect: (Date) -> Void

    private var days: [Date] {
        Calendar.current.daysInMonth(for: currentMonth)
    }

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(spacing: 8) {
            weekdaysHeader
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(days, id: \.self) { date in
                    let entry = entries[date]
                    Button(action: { onSelect(date) }) {
                        VStack(spacing: 4) {
                            if let entry {
                                Image(systemName: entry.smiley)
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 24, height: 24)
                            }

                            Text("\(Calendar.current.component(.day, from: date))")
                                .font(.caption2)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var weekdaysHeader: some View {
        let symbols = Calendar.current.shortWeekdaySymbols
        return HStack {
            ForEach(symbols, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - Detail Sheet View

private struct HistoryDetailView: View {
    let date: Date
    let entry: MoodEntry?

    @State private var isPlaying = false

    var body: some View {
        VStack(spacing: 24) {
            Text(date, formatter: DateFormatter.longDate)
                .font(.title2)
                .fontWeight(.semibold)

            if let entry {
                Image(systemName: entry.smiley)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.yellow)

                Text("Stimmung: \(entry.moodLabel)")
                    .font(.headline)

                Button(action: { playAudio(path: entry.audioFilePath) }) {
                    HStack {
                        Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        Text(isPlaying ? "Stop" : "Sprachnachricht abspielen")
                    }
                    .font(.title3)
                    .padding()
                    .background(Color("AccentColor").opacity(0.1))
                    .cornerRadius(12)
                }
                .accessibilityLabel(isPlaying ? "Audio stoppen" : "Audio abspielen")
            } else {
                Text("Keine Einträge für diesen Tag.")
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
    }

    private func playAudio(path: String?) {
        guard let path else { return }

        if isPlaying {
            AudioPlayerManager.shared.play(path: "")
            isPlaying = false
        } else {
            AudioPlayerManager.shared.play(path: path)
            isPlaying = true
        }
    }
}

// MARK: - Preview

#Preview {
    HistoryView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}
