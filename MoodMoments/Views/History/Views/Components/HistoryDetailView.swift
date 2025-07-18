import SwiftUI

struct HistoryDetailView: View {
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