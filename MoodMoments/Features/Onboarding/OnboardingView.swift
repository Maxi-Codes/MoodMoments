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
                onboardPage(image: "waveform", title: "Willkommen bei Mood Moments!", subtitle: "Deine App, um deine Stimmung einfach per Sprache festzuhalten.")
                    .tag(0)
                onboardPage(image: "mic.circle.fill", title: "Sprich deine Stimmung aus", subtitle: "Halte jeden Tag deine Gefühle fest – einfach per Mikrofon.")
                    .tag(1)
                onboardPage(image: "rectangle.and.pencil.and.ellipsis", title: "Stimmung von Sprachform in Textform umwandeln", subtitle: "Lasse deine Stimmung per AI in Textform umwandeln").tag(2)
                onboardPage(image: "calendar", title: "Behalte den Überblick", subtitle: "Sieh dir deinen Stimmungsverlauf und hilfreiche Analysen an.")
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

    private func onboardPage(image: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("AccentColor"))
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text(subtitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }

    private func next() {
        if page < 3 {
            withAnimation { page += 1 }
        } else {
            hasSeenOnboarding = true
        }
    }
}
