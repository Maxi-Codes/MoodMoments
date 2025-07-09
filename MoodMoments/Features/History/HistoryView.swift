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
    @State private var selectedDay: IdentifiableDate? = nil
    
    @StateObject private var audioManager = AudioPlayerManager()
    
    @Query var moods: [MoodEntry]
    
    var body: some View {
        VStack() {
            HStack() {
                Text("Deine Streak: ")
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundColor(Color.orange)
                Text("\(viewModel.streak)")
            }
            .padding(.bottom)
            
            VStack(alignment: .center, spacing: 16) {
                header
                CalendarGrid(currentMonth: viewModel.currentMonth, entries: viewModel.groupedEntries) { date in
                    selectedDay = IdentifiableDate(id: date)            }
                
            }
            .sheet(item: $selectedDay) { wrapper in
                let date = wrapper.id
                HistoryDetailView(date: date, entry: viewModel.groupedEntries[date])
            }
            Spacer()
            Text("Das war die Stimmung der letzten 3 Tage:")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            VStack(spacing: 16) {
                ForEach(moods) { mood in
                    let dateText = viewModel.formatDate(date: mood.date)
                    MoodRow(
                        mood: mood,
                        dateText: dateText,
                        onPlay: {
                            audioManager.play(path: mood.audioFilePath ?? "")
                        }
                    )
                }
            }

            Spacer()
        }
        .padding(.horizontal)
    }

    private var header: some View {
        HStack {
            Button(action: { viewModel.changeMonth(by: -1) }) { Image(systemName: "chevron.left") }
            Spacer()
            Text(viewModel.currentMonth, formatter: DateFormatter.monthAndYear)
                .font(.headline)
            Spacer()
            Button(action: { viewModel.changeMonth(by: 1) }) { Image(systemName: "chevron.right") }
        }
        .padding(.horizontal)
    }
}

struct MoodRow: View {
    let mood: MoodEntry
    let dateText: String
    let onPlay: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: mood.smiley)
                .font(.title2)
                .foregroundColor(.orange)

            Text("\(dateText) - \(mood.moodLabel)")

            Spacer()

            Button(action: onPlay) {
                Image(systemName: "play")
                    .font(.title2)
                    .foregroundColor(Color("AccentColor"))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }
}


// MARK: – Calendar Grid

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
                        VStack {
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
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private var weekdaysHeader: some View {
        let symbols = Calendar.current.shortWeekdaySymbols
        return HStack {
            ForEach(symbols, id: \.self) { day in
                Text(day).font(.caption).frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: – Detail Sheet

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
            AudioPlayerManager.shared.play(path: "") // stop by playing empty
            isPlaying = false
        } else {
            AudioPlayerManager.shared.play(path: path)
            isPlaying = true
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}
