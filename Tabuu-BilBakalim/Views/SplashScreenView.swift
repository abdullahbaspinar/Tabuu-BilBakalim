//
//  SplashScreenView.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @Binding var showHome: Bool
    
    var body: some View {
        ZStack {
            Color("FourthColor")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("TABUU")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(Color("PrimaryColor"))
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("Bil Bakalım")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(Color("SecondaryColor"))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeIn(duration: 0.3)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showHome = true
                }
            }
        }
    }
}

