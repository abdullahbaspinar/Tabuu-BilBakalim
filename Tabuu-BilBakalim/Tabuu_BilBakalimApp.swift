//
//  Tabuu_BilBakalimApp.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

@main
struct Tabuu_BilBakalimApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
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
