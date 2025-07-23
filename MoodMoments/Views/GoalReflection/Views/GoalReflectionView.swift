//
//  GoalReflectionView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 22.07.25.
//

import SwiftUI
import SwiftData


import SwiftUI
import SwiftData

enum ActiveSheet: Identifiable {
    case newGoal, newReflection
    var id: Int { hashValue }
}

struct GoalReflectionOverviewView: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \GoalEntry.date, order: .reverse) private var goals: [GoalEntry]
    @Query(sort: \ReflectionEntry.date, order: .reverse) private var reflections: [ReflectionEntry]
    
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        NavigationView {
            List {
                if !activeGoals.isEmpty {
                    Section(header: Text("Ziele")) {
                        ForEach(activeGoals) { goal in
                            goalRow(goal: goal)
                        }
                        .onDelete { indexSet in
                            deleteGoals(at: indexSet, from: activeGoals)
                        }
                    }
                }

                if !completedGoals.isEmpty {
                    Section(header: Text("Erledigte Ziele")) {
                        ForEach(completedGoals) { goal in
                            goalRow(goal: goal)
                        }
                        .onDelete { indexSet in
                            deleteGoals(at: indexSet, from: completedGoals)
                        }
                    }
                }

                if !reflections.isEmpty {
                    Section(header: Text("Reflexionen")) {
                        ForEach(reflections) { reflection in
                            ReflectionRow(reflection: reflection)
                        }
                        .onDelete { indexSet in
                            deleteReflections(at: indexSet)
                        }
                    }
                }

                if goals.isEmpty && reflections.isEmpty {
                    Text("Noch keine Ziele oder Reflexionen. Tippe auf '+' oben rechts, um zu starten.")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Neues Ziel") {
                            activeSheet = .newGoal
                        }
                        Button("Neue Reflexion") {
                            activeSheet = .newReflection
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .newGoal:
                    NewGoalView()
                case .newReflection:
                    NewReflectionView()
                }
            }
        }
    }

    private var activeGoals: [GoalEntry] {
        goals.filter { $0.isCompleted == false }
    }

    private var completedGoals: [GoalEntry] {
        goals.filter { $0.isCompleted == true }
    }

    private func goalRow(goal: GoalEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.goal)
                    .font(.headline)
                    .strikethrough(goal.isCompleted, color: .gray)
                    .foregroundColor(goal.isCompleted ? .gray : .primary)
                Text(goal.desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Deadline: \(goal.date, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                toggleGoalCompletion(goal)
            }) {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundColor(goal.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
    
    private func deleteGoals(at offsets: IndexSet, from source: [GoalEntry]) {
        for index in offsets {
            let goal = source[index]
            context.delete(goal)
        }
        try? context.save()
    }

    private func deleteReflections(at offsets: IndexSet) {
        for index in offsets {
            let reflection = reflections[index]
            context.delete(reflection)
        }
        try? context.save()
    }

    private func toggleGoalCompletion(_ goal: GoalEntry) {
        goal.isCompleted.toggle()
        try? context.save()
        
        if goal.isCompleted {
            NotificationManager.shared.cancelGoalReminder(for: goal)
        } else {
            NotificationManager.shared.scheduleGoalReminder(for: goal)
        }
    }

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }
}

struct NewGoalView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Date()
    @FocusState private var focusedField: Field?

    enum Field {
        case title, description
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Titel") {
                        TextField("Ziel Titel", text: $title)
                            .focused($focusedField, equals: .title)
                    }

                    Section("Beschreibung") {
                        TextField("Beschreibung", text: $description)
                            .focused($focusedField, equals: .description)
                    }

                    Section("Deadline") {
                        DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                    }
                }

                Spacer()

                Button(action: {
                    guard !title.isEmpty else { return }
                    let newGoal = GoalEntry(goal: title, description: description, date: deadline)
                    context.insert(newGoal)
                    try? context.save()
                    CheckAnimationManager.shared.showCheckAnimation("Dein Ziel wurde gespeichert.")
                    NotificationManager.shared.scheduleGoalReminder(for: newGoal)
                    dismiss()
                }) {
                    Text("Speichern")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(title.isEmpty ? Color.gray.opacity(0.5) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .disabled(title.isEmpty)
            }
            .navigationTitle("Neues Ziel")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear { focusedField = .title }
    }
}

struct NewReflectionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var text = ""
    @FocusState private var focusedField: Bool

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Reflexion") {
                        TextEditor(text: $text)
                            .frame(minHeight: 200, maxHeight: 250)
                            .focused($focusedField)
                    }
                }

                Spacer()

                Button(action: {
                    guard !text.isEmpty else { return }
                    let newReflection = ReflectionEntry(text: text)
                    context.insert(newReflection)
                    do {
                        try context.save()
                    } catch {
                        print("Fehler beim Speichern: \(error.localizedDescription)")
                    }
                    CheckAnimationManager.shared.showCheckAnimation("Deine Reflexion wurde gespeichert.")
                    dismiss()
                }) {
                    Text("Speichern")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(text.isEmpty ? Color.gray.opacity(0.5) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .disabled(text.isEmpty)
            }
            .navigationTitle("Neue Reflexion")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear { focusedField = true }
    }
}

struct ReflectionRow: View {
    let reflection: ReflectionEntry
    @State private var showFullText = false
    private let characterLimit = 100

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(displayedText)
                .font(.body)
                .animation(.easeInOut, value: showFullText)

            if isTruncated {
                Button(action: {
                    showFullText.toggle()
                }) {
                    Text(showFullText ? "Weniger anzeigen" : "Mehr anzeigen")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.top, 2)
                }
                .buttonStyle(.plain)
            }

            Text("\(reflection.date, formatter: dateFormatter)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }

    private var isTruncated: Bool {
        reflection.text.count > characterLimit
    }

    private var displayedText: String {
        if showFullText || !isTruncated {
            return reflection.text
        } else {
            let index = reflection.text.index(reflection.text.startIndex, offsetBy: characterLimit)
            return String(reflection.text[..<index]) + "..."
        }
    }

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }
}
