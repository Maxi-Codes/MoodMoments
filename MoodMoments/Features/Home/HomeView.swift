import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showMoodSheet = false
    @State private var selectedMood: Int? = nil
    @State private var selectedOption: String = "10 Sekunden"
    @State private var time: Int = 10

    @ObservedObject var viewModel: HomeViewModel

    let freeOption = "10 Sekunden"
    let premiumOptions = ["15 Sekunden", "20 Sekunden", "30 Sekunden", "60 Sekunden"]
    let timeOptions: [String: Int] = [
        "10 Sekunden": 10,
        "15 Sekunden": 15,
        "20 Sekunden": 20,
        "30 Sekunden": 30,
        "60 Sekunden": 60
    ]

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // BOX 1: Aufnahme
                VStack(spacing: 16) {
                    Text("Wie fühlst du dich heute?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("Drücke auf das Mikrofon und sprich frei über deinen Tag.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    ZStack {
                        Circle()
                            .fill(Color("AccentColor").opacity(0.2))
                            .frame(width: 180, height: 180)

                        Button(action: {
                            viewModel.toggleRecording(time: time)
                        }) {
                            Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(Color("AccentColor"))
                                .shadow(radius: 8)
                        }
                        .accessibilityLabel(viewModel.isRecording ? "Aufnahme stoppen" : "Aufnahme starten")
                    }

                    if viewModel.isRecording {
                        Text(String(format: "%02d:%02d", viewModel.secondsElapsed / 60, viewModel.secondsElapsed % 60))
                            .font(.title2)
                            .monospacedDigit()
                            .foregroundColor(Color("AccentColor"))
                    }

                    Menu {
                        ForEach(timeOptions.sorted(by: { $0.value < $1.value }), id: \.key) { label, value in
                            if label == freeOption {
                                Button(action: {
                                    selectedOption = label
                                    time = value
                                }) {
                                    Label(label, systemImage: selectedOption == label ? "checkmark" : "")
                                }
                            } else {
                                Label {
                                    HStack {
                                        Text(label)
                                        Spacer()
                                        Text("Mit Premium freischalten")
                                            .font(.caption2)
                                            .foregroundColor(.blue)
                                            .italic()
                                    }
                                } icon: {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.gray)
                                }
                                .disabled(true)
                            }
                        }
                    } label: {
                        Label(selectedOption, systemImage: "chevron.down")
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.blue)
                    }

                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal)

                // BOX 2: Tagesimpulse (3 Stück)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tagesimpulse")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 12) {
                        impulseView(text: "„Jeder Tag ist eine neue Chance.“", icon: "sunrise.fill")
                        impulseView(text: "„Es ist okay, nicht okay zu sein.“", icon: "cloud.drizzle.fill")
                        impulseView(text: "„Du bist weiter als du denkst.“", icon: "figure.walk.circle.fill")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .padding(.bottom, 40)
        }

    }

    private var moodSheet: some View {
        VStack(spacing: 24) {
            Text("Wie war deine Stimmung?")
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 16) {
                ForEach(1...5, id: \.self) { mood in
                    Button(action: {
                        selectedMood = mood
                        showMoodSheet = false
                        viewModel.saveMood(mood: mood, audioLenght: time)
                    }) {
                        Image(systemName: viewModel.smiley(for: mood))
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("AccentColor"))
                            .opacity(selectedMood == mood ? 1.0 : 0.7)
                    }
                    .accessibilityLabel(viewModel.smileyLabel(for: mood))
                }
            }

            Text("1 = sehr schlecht, 5 = sehr gut")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private func impulseView(text: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .italic()
                .font(.subheadline)
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

}
