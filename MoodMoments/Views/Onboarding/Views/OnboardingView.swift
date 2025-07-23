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
                OnboardPage(
                    image: "waveform",
                    title: "Willkommen bei Mood Moments!",
                    subtitle: "Deine persönliche App, um deine Stimmung ganz einfach mit der Stimme festzuhalten."
                )
                .tag(0)
                
                OnboardPage(
                    image: "mic.circle.fill",
                    title: "Sag uns, wie du dich fühlst",
                    subtitle: "Nimm täglich kurze Sprachaufnahmen auf, um deine Gefühle authentisch zu dokumentieren."
                )
                .tag(1)
                
                OnboardPage(
                    image: "rectangle.and.pencil.and.ellipsis",
                    title: "Automatische Stimmungsübersetzung",
                    subtitle: "Unsere KI wandelt deine Sprache in verständlichen Text um – so behältst du den Überblick."
                )
                .tag(2)
                
                OnboardPage(
                    image: "calendar",
                    title: "Verfolge deine Entwicklung",
                    subtitle: "Sieh deine Stimmung im Zeitverlauf und entdecke hilfreiche Einblicke und Tipps."
                )
                .tag(3)
                
                OnboardPage(
                    image: "checklist",
                    title: "Setze Ziele & reflektiere",
                    subtitle: "Erstelle persönliche Ziele und halte tägliche Reflektionen fest – für mehr Achtsamkeit und Klarheit im Alltag."
                )
                .tag(4)
                
                OnboardPage(
                        image: "lock.shield",
                        title: "Deine Daten bleiben privat",
                        subtitle: "Alle Daten werden ausschließlich lokal auf deinem Gerät gespeichert – kein Server, keine Cloud. Für maximale Privatsphäre."
                    )
                    .tag(5)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .padding(.top, 40)

            Spacer()
            Button(action: next) {
                Text(page < 5 ? "Weiter" : "Los geht's!")
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
        if page < 5 {
            withAnimation { page += 1 }
        } else {
            hasSeenOnboarding = true
        }
    }
}
