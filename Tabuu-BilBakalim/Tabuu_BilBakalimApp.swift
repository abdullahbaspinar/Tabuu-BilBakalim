//
//  Tabuu_BilBakalimApp.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

@main
struct Tabuu_BilBakalimApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        // Bildirim kategorilerini ayarla
        NotificationManager.shared.setupNotificationCategories()
        // Bildirim izni iste
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .background {
                        // Uygulama arka plana geçtiğinde bildirim zamanla
                        NotificationManager.shared.scheduleReturnNotification(afterHours: 24)
                    } else if newPhase == .active {
                        // Uygulama aktif olduğunda bildirimleri temizle
                        UNUserNotificationCenter.current().setBadgeCount(0)
                    }
                }
        }
    }
}

struct MainAppView: View {
    @State private var showHome = false
    
    var body: some View {
        Group {
            if showHome {
                NavigationStack {
                    HomeView()
                }
            } else {
                SplashScreenView(showHome: $showHome)
            }
        }
    }
}
