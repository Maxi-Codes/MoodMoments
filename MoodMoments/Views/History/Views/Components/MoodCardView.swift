import SwiftUI

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