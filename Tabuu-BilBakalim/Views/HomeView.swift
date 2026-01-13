//
//  HomeView.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Color("FourthColor")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image("logo")
                        .resizable()
                        .renderingMode(.original)
                        .antialiased(true)
                        .interpolation(.high)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    
                    
                }
                
                Spacer()
                
                VStack(spacing: 30) {
                    // Play Button
                    NavigationLink(destination: GameSetupView()) {
                        ZStack {
                            Circle()
                                .fill(Color("PrimaryColor"))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Settings Button
                    Button(action: {
                        showSettings = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color("ThirdColor"))
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("FourthColor")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("Yakında")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color("SecondaryColor"))
                    Spacer()
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundColor(Color("PrimaryColor"))
                }
            }
        }
    }
}

