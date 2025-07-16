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

struct DayEntries: Identifiable, Equatable {
    let id: Date
    let entries: [MoodEntry]
}

public struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    @StateObject private var audioManager = AudioPlayerManager()

    @State private var selectedDay: IdentifiableDate?
    @State private var showAllSheet = false
    @State private var selectedDayEntries: DayEntries? = nil
    @Query private var moods: [MoodEntry]

    public init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(context: modelContext))
    }

    public var body: some View {
        let _ = Self._printChanges()
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
                        entries: viewModel.groupedEntries,
                        onSelect: { date, entries in
                            selectedDayEntries = DayEntries(id: date, entries: entries)
                        }
                    )
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .sheet(item: $selectedDayEntries) { dayEntries in
                    VStack(spacing: 16) {
                        Text(dayEntries.id, formatter: DateFormatter.germanLongDate)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 8)
                        if dayEntries.entries.isEmpty {
                            Text("Keine Einträge für diesen Tag.")
                                .foregroundColor(.secondary)
                        } else {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(dayEntries.entries) { mood in
                                        MoodCardView(mood: mood, onPlay: {
                                            audioManager.play(path: mood.audioFilePath ?? "")
                                        })
                                    }
                                }
                                .padding(.bottom, 24)
                            }
                        }
                    }
                    .padding()
                }

                // MARK: - Last 3 Days Box
                VStack(spacing: 16) {
                    Text("Das war die Stimmung der letzten 3 Tage:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if moodsLast3Days.isEmpty {
                        Text("Kein Eintrag gefunden")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(moodsLast3Days) { mood in
                                MoodCardView(mood: mood, onPlay: {
                                    audioManager.play(path: mood.audioFilePath ?? "")
                                })
                            }
                        }
                        ZStack {
                            HStack { Spacer() }
                            HStack {
                                Spacer()
                                Button(action: { showAllSheet = true }) {
                                    HStack(spacing: 4) {
                                        Text("Alle anzeigen")
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                }
                                .buttonStyle(LinkButtonStyle())
                                .accessibilityLabel("Alle anzeigen")
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .sheet(isPresented: $showAllSheet) {
                    AllMoodsSheet(moods: moods.sorted(by: { $0.date > $1.date }), viewModel: viewModel, audioManager: audioManager, onClose: { showAllSheet = false })
                }

                Spacer(minLength: 40)
            }
        }
        .task {
            await viewModel.fetchEntries()
        }
        .onChange(of: moods) { _ in
            Task { await viewModel.fetchEntries() }
        }
    }

    // MARK: - Calendar Header
    private var calendarHeader: some View {
        HStack {
            Button(action: { viewModel.changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(viewModel.currentMonth, formatter: DateFormatter.germanMonthAndYear)
                .font(.headline)
                .environment(\.locale, Locale(identifier: "de_DE"))
            Spacer()
            Button(action: { viewModel.changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
            }
        }
    }
}

struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .underline(configuration.isPressed, color: .blue)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Mood Row

struct MoodRow: View {
    let mood: MoodEntry
    let dateText: String
    let onPlay: () -> Void
    let viewModel: HistoryViewModel

    var body: some View {
        DisclosureGroup {
            VStack {
                HStack(alignment: .center) {
                    Text("Audio: \(mood.audioLenght ?? 0) Sekunden")
                    Spacer()
                    Button(action: onPlay) {
                        Image(systemName: "play.fill")
                            .foregroundColor(Color("AccentColor"))
                    }
                }
                .padding(.bottom, 2)
                HStack(alignment: .firstTextBaseline) {
                    Text("Transkripiert:")
                    Text(mood.transcript ?? "-")
                    Spacer()
                }
            }
            .padding(.vertical)
        } label: {
            HStack(alignment: .center, spacing: 8) {
                Text("\(dateText) - \(mood.moodLabel)")
                    .font(.subheadline)
                Image(systemName: mood.smiley)
                    .foregroundColor(viewModel.smileyColor(for: mood.mood))
            }
        }
    }
}

// MARK: - Calendar Grid

private struct CalendarGrid: View {
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
                if let transcript = entry.transcript, !transcript.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Transkription:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(transcript)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.vertical, 4)
                    }
                }

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
        .padding(.vertical)
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

// Hilfs-Property für alle MoodEntry der letzten 3 Kalendertage
extension HistoryView {
    private var moodsLast3Days: [MoodEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let last3 = (0..<3).map { calendar.date(byAdding: .day, value: -$0, to: today)! }
        return moods.filter { entry in
            let entryDay = calendar.startOfDay(for: entry.date)
            return last3.contains(entryDay)
        }.sorted(by: { $0.date > $1.date })
    }
}

// Neue View für das Popup
struct AllMoodsSheet: View {
    let moods: [MoodEntry]
    let viewModel: HistoryViewModel
    let audioManager: AudioPlayerManager
    let onClose: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(8)
                    }
                }
                .padding(.top, 8)
                .padding(.trailing, 8)
                Text("Alle Aufnahmen")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(moods) { mood in
                            MoodRow(
                                mood: mood,
                                dateText: viewModel.formatDate(date: mood.date),
                                onPlay: {
                                    audioManager.play(path: mood.audioFilePath ?? "")
                                },
                                viewModel: viewModel,
                            )
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal)
            }
            .background(Color(.systemBackground))
        }
    }
}

// DateFormatter für deutschen Monat und langes Datum
extension DateFormatter {
    static let germanMonthAndYear: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "de_DE")
        df.setLocalizedDateFormatFromTemplate("LLLL yyyy")
        return df
    }()
    static let germanLongDate: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "de_DE")
        df.dateStyle = .long
        df.timeStyle = .none
        return df
    }()
}

// Neue moderne Card-Ansicht für Mood-Eintrag im Sheet
struct MoodCardView: View {
    let mood: MoodEntry
    let onPlay: () -> Void
    @ObservedObject private var audioManager = AudioPlayerManager.shared
    @State private var showMissingFileAlert = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: mood.smiley)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(mood.smileyColor)
                VStack(alignment: .leading, spacing: 2) {
                    Text(mood.moodLabel)
                        .font(.headline)
                    if let time = mood.audioLenght {
                        Text("Dauer: \(time) Sek.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text(mood.date, formatter: DateFormatter.germanLongDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if audioManager.isPlaying && audioManager.currentTime > 0 && audioManager.duration > 0 && audioManager.currentFilePath == mood.audioFilePath {
                    Button(action: { audioManager.pause() }) {
                        Image(systemName: "pause.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color("AccentColor"))
                    }
                } else {
                    Button(action: {
                        if !AudioPlayerManager.shared.fileExists(path: mood.audioFilePath) {
                            showMissingFileAlert = true
                        } else {
                            onPlay()
                        }
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
            .alert(isPresented: $showMissingFileAlert) {
                Alert(title: Text("Datei nicht gefunden"), message: Text("Die Audiodatei existiert nicht mehr. Sie wurde vermutlich beim App-Update oder Clean gelöscht."), dismissButton: .default(Text("OK")))
            }
            if audioManager.isPlaying && audioManager.currentFilePath == mood.audioFilePath {
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: audioManager.currentTime, total: audioManager.duration)
                        .accentColor(Color("AccentColor"))
                    HStack {
                        Text(audioManager.currentTime.timeString)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(audioManager.duration.timeString)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            if let transcript = mood.transcript, !transcript.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Transkription:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(transcript)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(6)
                        .background(Color(.tertiarySystemBackground))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
                .shadow(color: Color.gray.opacity(0.08), radius: 8, x: 0, y: 2)
        )
        .padding(.vertical, 8)
    }
}

// Hilfs-Extension für Zeitformatierung
extension TimeInterval {
    var timeString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
