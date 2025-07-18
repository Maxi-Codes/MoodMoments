//  AnalyseView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.

import SwiftUI
import Charts
import SwiftData

struct AnalyseView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AnalyseViewModel

    init() {
        _viewModel = StateObject(wrappedValue: AnalyseViewModel())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ChartBox(title: "Letzte 7 Tage", stats: viewModel.last7Days, isLocked: false)
                ChartBox(title: "Letzte 14 Tage", stats: viewModel.last14Days, isLocked: false)
                ChartBox(title: "Letzte 30 Tage", stats: viewModel.last30Days, isLocked: false)
            }
            .padding(.vertical)
        }
        .onAppear {
            viewModel.setContext(modelContext)
            viewModel.fetch()
        }
    }
}
