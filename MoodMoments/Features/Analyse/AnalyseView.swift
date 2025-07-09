//  AnalyseView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.

import SwiftUI
import Charts
import SwiftData

struct AnalyseView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AnalyseViewModel

    init() {
        _viewModel = StateObject(wrappedValue: AnalyseViewModel())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Letzte 7 Tage (frei verfügbar)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Letzte 7 Tage")
                        .font(.headline)
                    Chart(viewModel.last7Days) { stat in
                        BarMark(
                            x: .value("Tag", stat.date, unit: .day),
                            y: .value("Mood", stat.averageMood)
                        )
                        .foregroundStyle(Color("AccentColor"))
                        .accessibilityLabel(Text("\(stat.date, formatter: DateFormatter.shortWeekday): \(stat.averageMood, specifier: "%.1f")"))
                    }
                    .chartYScale(domain: 0...5)
                    .frame(height: 220)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(radius: 4)
                .padding(.horizontal)
                .onAppear { viewModel.fetch() }

                // Letzte 14 Tage (Premium)
                ZStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Letzte 14 Tage")
                            .font(.headline)
                        Chart(viewModel.last7Days) { stat in
                            BarMark(
                                x: .value("Tag", stat.date, unit: .day),
                                y: .value("Mood", stat.averageMood)
                            )
                            .foregroundStyle(Color("AccentColor"))
                            .accessibilityLabel(Text("\(stat.date, formatter: DateFormatter.shortWeekday): \(stat.averageMood, specifier: "%.1f")"))
                        }
                        .chartYScale(domain: 0...5)
                        .frame(height: 220)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .blur(radius: 3)

                    HStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                        Text("Mit Premium freischalten")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .shadow(radius: 2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.20))
                    .cornerRadius(16)
                }
                .padding(.horizontal)

                // Letzte 30 Tage (Premium)
                ZStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Letzte 30 Tage")
                            .font(.headline)
                        Chart(viewModel.last7Days) { stat in
                            BarMark(
                                x: .value("Tag", stat.date, unit: .day),
                                y: .value("Mood", stat.averageMood)
                            )
                            .foregroundStyle(Color("AccentColor"))
                            .accessibilityLabel(Text("\(stat.date, formatter: DateFormatter.shortWeekday): \(stat.averageMood, specifier: "%.1f")"))
                        }
                        .chartYScale(domain: 0...5)
                        .frame(height: 220)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .blur(radius: 3)

                    HStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                        Text("Mit Premium freischalten")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .shadow(radius: 2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.20))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear {
            // Übergib modelContext an ViewModel, wenn der View erscheint
            viewModel.setContext(modelContext)
            viewModel.fetch()
        }
    }
}
