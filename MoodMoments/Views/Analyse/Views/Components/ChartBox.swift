import SwiftUI
import Charts

struct ChartBox: View {
    let title: String
    let stats: [AnalyseViewModel.DayStat]
    let isLocked: Bool
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.headline)
                Chart(stats) { stat in
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
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .shadow(radius: 4)
            .blur(radius: isLocked ? 3 : 0)
            if isLocked {
                LockedChartOverlay()
            }
        }
        .padding(.horizontal)
    }
} 
