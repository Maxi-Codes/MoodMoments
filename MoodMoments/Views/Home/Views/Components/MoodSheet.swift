import SwiftUI

struct MoodSheet: View {
    @Binding var selectedMood: Int?
    let time: Int
    let onSelect: (Int) -> Void
    let smiley: (Int) -> String
    let smileyColor: (Int) -> Color
    let smileyLabel: (Int) -> String
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Wie war deine Stimmung?")
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 16) {
                ForEach(1...5, id: \.self) { mood in
                    Button(action: {
                        selectedMood = mood
                        onSelect(mood)
                    }) {
                        Image(systemName: smiley(mood))
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(smileyColor(mood))
                            .opacity(selectedMood == mood ? 1.0 : 0.6)
                            .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: selectedMood)
                    }
                    .accessibilityLabel(smileyLabel(mood))
                }
            }
            Text("1 = traurig, 5 = fröhlich")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
} 