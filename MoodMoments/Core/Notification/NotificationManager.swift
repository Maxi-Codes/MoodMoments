//
//  NotificationManager.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 22.07.25.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() { }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Benachrichtigungen erlaubt")
            } else {
                print("❌ Keine Erlaubnis: \(String(describing: error))")
            }
        }
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Wie fühlst du dich heute?"
        content.body = "Zeit für deine tägliche Stimmungseintragung 🎤"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 53

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyMoodReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Fehler beim Planen: \(error.localizedDescription)")
            } else {
                print("✅ Tägliche Erinnerung geplant")
            }
        }
    }

    // Erinnerung löschen
    func cancelDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyMoodReminder"])
        print("🔕 Erinnerung gelöscht")
    }
    
    func scheduleGoalReminder(for goal: GoalEntry) {
        guard !goal.isCompleted else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "⚠️ Dein Ziel läuft bald ab!"
        content.body = "„\(goal.goal)“ endet morgen. Noch nicht erledigt?"
        content.sound = .default

        let reminderDate = Calendar.current.date(byAdding: .day, value: -1, to: goal.date) ?? goal.date
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                             from: reminderDate.setTime(hour: 9, minute: 0))

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: "goalReminder-\(goal.id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Fehler beim Planen des Ziels: \(error.localizedDescription)")
            } else {
                print("✅ Erinnerung für Ziel geplant: \(goal.goal)")
            }
        }
    }

    func cancelGoalReminder(for goal: GoalEntry) {
        let id = "goalReminder-\(goal.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("🔕 Erinnerung für Ziel gelöscht: \(goal.goal)")
    }
}

extension Date {
    func setTime(hour: Int, minute: Int) -> Date {
        var calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components) ?? self
    }
}
