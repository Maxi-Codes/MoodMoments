//  HomeView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var showMoodSheet = false
    @State private var selectedMood: Int? = nil
    @State private var selectedOption: String = "Wähle die Länge aus";
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
        VStack {
            Spacer()

            VStack(spacing: 24) {
                Text("Wie fühlst du dich heute?")
                    .font(.title)
                    .fontWeight(.bold)
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
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }

            }
            .padding(.horizontal)
            .multilineTextAlignment(.center)

            Spacer()
        }
        .onChange(of: viewModel.didFinishRecording) { finished in
            if finished { showMoodSheet = true }
        }
        .sheet(isPresented: $showMoodSheet) { moodSheet }
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
                        viewModel.saveMood(mood: mood)
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
}

