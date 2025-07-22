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
}

