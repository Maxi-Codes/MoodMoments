//
//  MoodAdviceView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 22.07.25.
//

import SwiftUI

struct MoodAdviceView: View {
    @Environment(\.dismiss) private var dismiss

    let moodLevel: Int
    @State private var currentAdvice: String

    init(moodLevel: Int, adviceText: String) {
        self.moodLevel = moodLevel
        _currentAdvice = State(initialValue: adviceText)
    }

    var body: some View {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text(emojiForMood(moodLevel))
                        .font(.system(size: 60))
                    Text(titleForMood(moodLevel))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }

                Text(currentAdvice)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                    .transition(.opacity)
                    .id(currentAdvice)

                // Neuer Button, schön gestaltet
                Button(action: {
                    withAnimation {
                        currentAdvice = MoodAdvice.advice(for: moodLevel)
                    }
                }) {
                    Text("Noch ein Tipp anzeigen")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(Color.blue.opacity(0.15))
                        .foregroundColor(.blue)
                        .cornerRadius(25)
                        .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20)

                Spacer()

                Button(action: {
                    dismiss()
                }) {
                    Text("Verstanden")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 24)
            .frame(maxHeight: .infinity)
            .background(Color(.systemBackground))
        }

    func emojiForMood(_ mood: Int) -> String {
        switch mood {
        case 1: return "🌧️"
        case 2: return "😕"
        case 3: return "😐"
        case 4: return "😊"
        case 5: return "🌞"
        default: return "🤔"
        }
    }

    func titleForMood(_ mood: Int) -> String {
        switch mood {
        case 1: return "Du fühlst dich sehr schlecht"
        case 2: return "Es geht dir nicht so gut"
        case 3: return "Neutraler Tag"
        case 4: return "Dir geht's gut!"
        case 5: return "Hervorragend!"
        default: return "Unbekannter Zustand"
        }
    }
}

#Preview {
    MoodAdviceView(moodLevel: 1, adviceText: "Versuch einen Spaziergang und trinke ausreichend Wasser.")
}
