//  AnalyseView.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import SwiftUI
import Charts

struct AnalyseView: View {
    @StateObject private var viewModel = AnalyseViewModel()

    var body: some View {
        ScrollView {
            VStack() {
                // 7 Tage (frei verfügbar)
                VStack(alignment: .leading, spacing: 24) {
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
                    Spacer()
                }
                .padding()
                .onAppear { viewModel.fetch() }
                
                // 14 Tage (Premium, verschwommen mit Overlay)
                ZStack {
                    VStack(alignment: .leading, spacing: 24) {
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
                        Spacer()
                    }
                    .padding()
                    .blur(radius: 3) // Verschwommener Effekt
                    
                    // Overlay Hinweis
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
                    .cornerRadius(10)
                }
                .padding()
                
                // 30 Tage (Premium, verschwommen mit Overlay)
                ZStack {
                    VStack(alignment: .leading, spacing: 24) {
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
                        Spacer()
                    }
                    .padding()
                    .blur(radius: 3) // Verschwommener Effekt
                    
                    // Overlay Hinweis
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
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    AnalyseView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}
