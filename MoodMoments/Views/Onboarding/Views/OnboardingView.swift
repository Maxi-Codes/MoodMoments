//  OnboardingView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var page = 0

    var body: some View {
        VStack {
            TabView(selection: $page) {
                OnboardPage(image: "waveform", title: "Willkommen bei Mood Moments!", subtitle: "Deine App, um deine Stimmung einfach per Sprache festzuhalten.")
                    .tag(0)
                OnboardPage(image: "mic.circle.fill", title: "Sprich deine Stimmung aus", subtitle: "Halte jeden Tag deine Gefühle fest – einfach per Mikrofon.")
                    .tag(1)
                OnboardPage(image: "rectangle.and.pencil.and.ellipsis", title: "Stimmung von Sprachform in Textform umwandeln", subtitle: "Lasse deine Stimmung per AI in Textform umwandeln").tag(2)
                OnboardPage(image: "calendar", title: "Behalte den Überblick", subtitle: "Sieh dir deinen Stimmungsverlauf und hilfreiche Analysen an.")
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .padding(.top, 40)

            Spacer()
            Button(action: next) {
                Text(page < 3 ? "Weiter" : "Los geht's!")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }

    private func next() {
        if page < 3 {
            withAnimation { page += 1 }
        } else {
            hasSeenOnboarding = true
        }
    }
}
