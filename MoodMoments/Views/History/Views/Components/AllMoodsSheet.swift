import SwiftUI

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