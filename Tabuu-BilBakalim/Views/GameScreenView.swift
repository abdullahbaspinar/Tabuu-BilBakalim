//
//  GameScreenView.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

struct GameScreenView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var dragOffset: CGSize = .zero
    @State private var showPauseAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color("FourthColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Timer Bar
                TimerBarView(
                    timeRemaining: viewModel.timeRemaining,
                    totalTime: viewModel.gameSettings.duration,
                    onPause: {
                        viewModel.pauseGame()
                        showPauseAlert = true
                    }
                )
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Current Team
                Text(viewModel.currentTeam.name.uppercased())
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color("PrimaryColor"))
                    .padding(.vertical, 20)
                
                Spacer()
                
                // Card
                if let card = viewModel.currentCard {
                    GameCardView(
                        card: card,
                        dragOffset: $dragOffset,
                        onCorrect: {
                            viewModel.handleCorrect()
                            withAnimation {
                                dragOffset = .zero
                            }
                        },
                        onWrong: {
                            viewModel.handleWrong()
                            withAnimation {
                                dragOffset = .zero
                            }
                        }
                    )
                    .padding(.horizontal)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
                
                Spacer()
                
                // Control Buttons
                ControlButtonsView(
                    onWrong: {
                        viewModel.handleWrong()
                    },
                    onPass: {
                        viewModel.handlePass()
                    },
                    onCorrect: {
                        viewModel.handleCorrect()
                    },
                    passUsed: viewModel.usedPassCount,
                    passLimit: viewModel.gameSettings.passLimit
                )
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if !viewModel.isTimerRunning {
                viewModel.startGame()
            }
        }
        .onChange(of: viewModel.shouldShowGameOver) { newValue in
            if !newValue && !viewModel.isTimerRunning {
                // Game was restarted, start the game
                viewModel.startGame()
            }
        }
        .alert("Oyun Durduruldu", isPresented: $showPauseAlert) {
            Button("Devam") {
                viewModel.resumeGame()
            }
            Button("Kuruluma Dön", role: .destructive) {
                viewModel.pauseGame()
                dismiss()
            }
        } message: {
            Text("Ne yapmak istersiniz?")
        }
        .fullScreenCover(isPresented: $viewModel.shouldShowChangeScreen) {
            ChangeScreenView(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.shouldShowGameOver) {
            GameOverView(viewModel: viewModel) {
                dismiss()
            }
        }
    }
}

struct TimerBarView: View {
    let timeRemaining: Int
    let totalTime: Int
    let onPause: () -> Void
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(timeRemaining) / Double(totalTime)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ProgressView(value: progress)
                    .tint(Color("PrimaryColor"))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                Text("Kalan: \(timeRemaining) sn")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("SecondaryColor"))
                    .frame(width: 100)
                
                Button(action: onPause) {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color("PrimaryColor"))
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("SecondaryColor"))
                .opacity(0.3)
        )
    }
}

struct GameCardView: View {
    let card: GameCard
    @Binding var dragOffset: CGSize
    let onCorrect: () -> Void
    let onWrong: () -> Void
    
    @State private var showFeedback: String? = nil
    @State private var hasTriggeredHaptic = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color("SecondaryColor"), Color("SecondaryColor").opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [Color("ThirdColor"), Color("ThirdColor").opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.black.opacity(0.4), radius: 15, x: 0, y: 8)
            
            VStack(spacing: 28) {
                Text(card.mainWord)
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                Divider()
                    .background(Color.white.opacity(0.6))
                    .frame(height: 2)
                    .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 18) {
                    Text("Yasak Kelimeler:")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("ThirdColor"))
                    
                    ForEach(card.forbiddenWords, id: \.self) { word in
                        HStack(spacing: 12) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color("PrimaryColor"))
                            Text(word)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 36)
            
            // Feedback overlay - shows during swipe
            if abs(dragOffset.width) > 30 {
                let feedbackType = dragOffset.width > 0 ? "DOĞRU" : "YANLIŞ"
                let feedbackColor = dragOffset.width > 0 ? Color.green : Color("PrimaryColor")
                let opacity = min(abs(dragOffset.width) / 150, 1.0)
                
                ZStack {
                    VStack(spacing: 16) {
                        Image(systemName: feedbackType == "DOĞRU" ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(feedbackColor)
                            .shadow(color: feedbackColor.opacity(0.4), radius: 15, x: 0, y: 0)
                        
                        Text(feedbackType)
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(feedbackColor)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 36)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: Color.black.opacity(0.25), radius: 15, x: 0, y: 8)
                    )
                    .opacity(opacity)
                    .scaleEffect(0.8 + (opacity * 0.2))
                }
                .transition(.opacity)
            }
            
            // Final feedback overlay - shows after swipe completes
            if let feedback = showFeedback {
                // Background overlay with color based on feedback
                let overlayColor = feedback == "DOĞRU" ? Color.green : Color("PrimaryColor")
                RoundedRectangle(cornerRadius: 28)
                    .fill(overlayColor.opacity(0.6))
                    .transition(.opacity)
                
                ZStack {
                    VStack(spacing: 20) {
                        Image(systemName: feedback == "DOĞRU" ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(feedback == "DOĞRU" ? .green : Color("PrimaryColor"))
                            .shadow(color: (feedback == "DOĞRU" ? Color.green : Color("PrimaryColor")).opacity(0.5), radius: 20, x: 0, y: 0)
                        
                        Text(feedback)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(feedback == "DOĞRU" ? .green : Color("PrimaryColor"))
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                    )
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(height: 420)
        .offset(dragOffset)
        .scaleEffect(1.0 - abs(dragOffset.width) / 1000)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                    // Haptic feedback during swipe (once per swipe)
                    if abs(value.translation.width) > 50 && !hasTriggeredHaptic {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        hasTriggeredHaptic = true
                    }
                }
                .onEnded { value in
                    let threshold: CGFloat = 120
                    if abs(value.translation.width) > threshold {
                        if value.translation.width > 0 {
                            // Right swipe - Correct
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showFeedback = "DOĞRU"
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                onCorrect()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    dragOffset = .zero
                                    showFeedback = nil
                                    hasTriggeredHaptic = false
                                }
                            }
                        } else {
                            // Left swipe - Wrong
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showFeedback = "YANLIŞ"
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                onWrong()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    dragOffset = .zero
                                    showFeedback = nil
                                    hasTriggeredHaptic = false
                                }
                            }
                        }
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            dragOffset = .zero
                            hasTriggeredHaptic = false
                        }
                    }
                }
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
    }
}

struct ControlButtonsView: View {
    let onWrong: () -> Void
    let onPass: () -> Void
    let onCorrect: () -> Void
    let passUsed: Int
    let passLimit: Int
    
    var body: some View {
        HStack(spacing: 40) {
            // Wrong Button
            Button(action: onWrong) {
                ZStack {
                    Circle()
                        .fill(Color("PrimaryColor"))
                        .frame(width: 75, height: 75)
                        .shadow(color: Color("PrimaryColor").opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(ScaleButtonStyle())
            
            // Pass Button with indicator
            VStack(spacing: 8) {
                if passLimit > 0 {
                    Text("\(passUsed)/\(passLimit)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color("SecondaryColor"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color("FourthColor").opacity(0.6))
                        )
                }
                
                Button(action: onPass) {
                    ZStack {
                        Circle()
                            .fill(passUsed >= passLimit ? Color("ThirdColor").opacity(0.5) : Color("SecondaryColor"))
                            .frame(width: 75, height: 75)
                            .shadow(color: (passUsed >= passLimit ? Color("ThirdColor") : Color("SecondaryColor")).opacity(0.4), radius: 8, x: 0, y: 4)
                        
                        Text("?")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(passUsed >= passLimit)
                .buttonStyle(ScaleButtonStyle())
            }
            
            // Correct Button
            Button(action: onCorrect) {
                ZStack {
                    Circle()
                        .fill(Color("Green"))
                        .frame(width: 75, height: 75)
                        .shadow(color: Color("Green").opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

