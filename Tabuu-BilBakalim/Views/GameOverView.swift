//
//  GameOverView.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    var onBackToHome: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color("FourthColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Winner Announcement
                    VStack(spacing: 16) {
                        Image("logo")
                            .resizable()
                            .renderingMode(.original)
                            .antialiased(true)
                            .interpolation(.high)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                        
                        Text("OYUN BİTTİ!")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(Color("PrimaryColor"))
                        
                        if let winner = viewModel.winningTeam {
                            Text("Kazanan:")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color("SecondaryColor"))
                            
                            Text(winner.name.uppercased())
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(Color("PrimaryColor"))
                            
                            Text("\(winner.score) Puan")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color("SecondaryColor"))
                        }
                    }
                    .padding(.vertical, 32)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("SecondaryColor").opacity(0.2))
                    )
                    .padding(.horizontal)
                    
                    // Final Leaderboard
                    LeaderboardCardView(teams: viewModel.teams.sorted { $0.score > $1.score })
                        .padding(.horizontal)
                    
                    // Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            viewModel.shouldShowGameOver = false
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.restartGame()
                            }
                        }) {
                            Text("Yeniden Başla")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(
                                    LinearGradient(
                                        colors: [Color("PrimaryColor"), Color("PrimaryColor").opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: {
                            viewModel.resetGame()
                            viewModel.shouldShowGameOver = false
                            dismiss()
                            // Call the callback to dismiss GameScreenView as well
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onBackToHome?()
                            }
                        }) {
                            Text("Ana Menü")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color("PrimaryColor"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color("SecondaryColor"))
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

