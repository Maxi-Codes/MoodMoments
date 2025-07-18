//
//  HistoryView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import SwiftUI
import SwiftData
// Importiere ausgelagerte Views und Extensions aus dem Components-Unterordner
// (Swift findet sie automatisch, wenn im gleichen Modul)

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
        let moodsLast3: [MoodEntry] = moodsLast3Days
        let allMoodsSorted: [MoodEntry] = moods.sorted(by: { $0.date > $1.date })
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

                    if moodsLast3.isEmpty {
                        Text("Kein Eintrag gefunden")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(moodsLast3) { mood in
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
                    AllMoodsSheet(moods: allMoodsSorted, viewModel: viewModel, audioManager: audioManager, onClose: { showAllSheet = false })
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

    // Hilfs-Property für alle MoodEntry der letzten 3 Kalendertage
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
