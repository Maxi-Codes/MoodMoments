import SwiftUI

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