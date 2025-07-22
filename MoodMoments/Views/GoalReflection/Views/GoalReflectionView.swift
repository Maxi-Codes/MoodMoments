//
//  GoalReflectionView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 22.07.25.
//

import SwiftUI
import SwiftData


struct Goal: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let deadline: Date
    var isCompleted: Bool = false
}

struct Reflection: Identifiable {
    let id = UUID()
    let text: String
    let date: Date
}

enum ActiveSheet: Identifiable {
    case newGoal, newReflection
    var id: Int { hashValue }
}

struct GoalReflectionOverviewView: View {
    @State private var goals: [Goal] = []
    @State private var reflections: [Reflection] = []
    @State private var activeSheet: ActiveSheet?
    @State private var focusedField: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                // Aktive Ziele
                if !goals.filter({ !$0.isCompleted }).isEmpty {
                    Section(header: Text("Ziele")) {
                        ForEach(goals.filter { !$0.isCompleted }) { goal in
                            goalRow(goal: goal, isCompleted: false)
                        }
                    }
                }
                
                // Erledigte Ziele
                if !goals.filter({ $0.isCompleted }).isEmpty {
                    Section(header: Text("Erledigte Ziele")) {
                        ForEach(goals.filter { $0.isCompleted }) { goal in
                            goalRow(goal: goal, isCompleted: true)
                        }
                    }
                }
                
                // Reflexionen
                if !reflections.isEmpty {
                    Section(header: Text("Reflexionen")) {
                        ForEach(reflections) { reflection in
                            ReflectionRow(reflection: reflection)
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
                    NewGoalView { newGoal in
                        goals.append(newGoal)
                        activeSheet = nil
                        focusedField = false
                        CheckAnimationManager.shared.showCheckAnimation("Dein Ziel wurde gespeichert.")
                    }
                case .newReflection:
                    NewReflectionView { newReflection in
                        reflections.append(newReflection)
                        activeSheet = nil
                        focusedField = false
                        CheckAnimationManager.shared.showCheckAnimation("Deine Reflexion wurde gespeichert.")
                    }
                }
            }
        }
    }
    
    // MARK: - Goal Row
    @ViewBuilder
    private func goalRow(goal: Goal, isCompleted: Bool) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.headline)
                    .strikethrough(isCompleted, color: .gray)
                    .foregroundColor(isCompleted ? .gray : .primary)
                Text(goal.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Deadline: \(goal.deadline, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                toggleGoalCompletion(goal)
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundColor(isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 6)
    }
    
    private func toggleGoalCompletion(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].isCompleted.toggle()
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
    
    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Date()
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title
        case description
    }
    
    var onSave: (Goal) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Titel") {
                        TextField("Ziel Titel", text: $title)
                            .focused($focusedField, equals: .title)
                            .padding(10)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    Section("Beschreibung") {
                        TextField("Beschreibung", text: $description)
                            .focused($focusedField, equals: .description)
                            .padding(10)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    Section("Deadline") {
                        DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.systemGroupedBackground))
                
                Spacer()
                
                Button(action: {
                    guard !title.isEmpty else { return }
                    hideKeyboard()
                    onSave(Goal(title: title, description: description, deadline: deadline))
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
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
        .onAppear {
            focusedField = .title
        }
    }
}

struct NewReflectionView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var text = ""
    @FocusState private var focusedField: Bool
    
    var onSave: (Reflection) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Reflexion") {
                        TextEditor(text: $text)
                            .frame(minHeight: 200, maxHeight: 250)
                            .focused($focusedField)
                            .padding(10)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.systemGroupedBackground))
                
                Spacer()
                
                Button(action: {
                    guard !text.isEmpty else { return }
                    hideKeyboard()
                    onSave(Reflection(text: text, date: Date()))
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
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
        .onAppear {
            focusedField = true
        }
    }
}

struct ReflectionRow: View {
    let reflection: Reflection
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
                .buttonStyle(PlainButtonStyle())
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

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
