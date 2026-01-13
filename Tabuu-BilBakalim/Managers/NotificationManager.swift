//
//  NotificationManager.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 12.01.2026.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Bildirim izni verildi")
            } else if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleReturnNotification(afterHours hours: Int = 24) {
        let center = UNUserNotificationCenter.current()
        
        // Önceki bildirimleri iptal et
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "TABUU - Geri Dön!"
        content.body = "Tabu oyununu özledin mi? Hemen oyuna devam et!"
        content.sound = .default
        content.badge = 1
        
        // Kategori ve action ekle
        content.categoryIdentifier = "RETURN_TO_GAME"
        
        // Zamanlamayı ayarla
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(hours * 3600), repeats: false)
        
        let request = UNNotificationRequest(identifier: "return_to_game", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Bildirim zamanlama hatası: \(error.localizedDescription)")
            } else {
                print("Bildirim zamanlandı: \(hours) saat sonra")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func setupNotificationCategories() {
        let returnAction = UNNotificationAction(identifier: "RETURN_ACTION", title: "Oyuna Dön", options: .foreground)
        let category = UNNotificationCategory(identifier: "RETURN_TO_GAME", actions: [returnAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
