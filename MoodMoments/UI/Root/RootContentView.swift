//  RootContentView.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import SwiftUI

struct RootContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @State private var showProSheet = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        ZStack {
            if hasSeenOnboarding {
                mainTabView
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            }
        }
    }

    private var mainTabView: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: HomeViewModel(context: modelContext))
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(0)
                HistoryView()
                    .tabItem { Label("Verlauf", systemImage: "calendar") }
                    .tag(1)
                AnalyseView()
                    .tabItem { Label("Analyse", systemImage: "chart.bar.xaxis") }
                    .tag(2)
                SettingsView()
                    .tabItem { Label("Einstell.", systemImage: "gearshape") }
                    .tag(3)
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showProSheet) {
                ProPurchaseView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showProSheet = true }) {
                        Image(systemName: "star.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color("AccentColor"))
                    }
                    .accessibilityLabel("Pro-Version kaufen")
                }
            }
        }
    }
}
