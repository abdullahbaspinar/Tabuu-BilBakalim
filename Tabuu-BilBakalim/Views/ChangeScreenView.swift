//
//  ChangeScreenView.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

struct ChangeScreenView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color("FourthColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Round Stats
                    StatsCardView(
                        title: "Tur İstatistikleri",
                        correct: viewModel.currentRoundStats.correctCount,
                        wrong: viewModel.currentRoundStats.wrongCount,
                        roundScore: viewModel.currentRoundStats.roundScore
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Current Team Score
                    TeamScoreCardView(
                        team: viewModel.currentTeam,
                        isCurrent: true
                    )
                    .padding(.horizontal)
                    
                    // All Teams Leaderboard
                    LeaderboardCardView(
                        teams: viewModel.teams.sorted { $0.score > $1.score },
                        currentTeamIndex: viewModel.currentTeamIndex
                    )
                    .padding(.horizontal)
                    
                    // Next Team Info
                    if viewModel.teams.count > 1 {
                        let nextTeamIndex = (viewModel.currentTeamIndex + 1) % viewModel.teams.count
                        let nextTeam = viewModel.teams[nextTeamIndex]
                        VStack(spacing: 12) {
                            Text("Sıradaki Takım")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color("PrimaryColor"))
                            
                            Text(nextTeam.name.uppercased())
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color("PrimaryColor"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("SecondaryColor").opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("PrimaryColor").opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal)
                    }
                    
                    // Continue Button
                    Button(action: {
                        viewModel.continueToNextTeam()
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.startRound()
                        }
                    }) {
                        Text("Hazır")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct StatsCardView: View {
    let title: String
    let correct: Int
    let wrong: Int
    let roundScore: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("SecondaryColor"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("ThirdColor"), lineWidth: 1)
                )
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 30) {
                    StatItemView(label: "Doğru", value: "\(correct)", color: Color("PrimaryColor"))
                    StatItemView(label: "Yanlış", value: "\(wrong)", color: Color("ThirdColor"))
                    StatItemView(label: "Tur Puanı", value: "\(roundScore)", color: Color("PrimaryColor"))
                }
            }
            .padding(24)
        }
    }
}

struct StatItemView: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

struct TeamScoreCardView: View {
    let team: Team
    let isCurrent: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(isCurrent ? Color("PrimaryColor").opacity(0.3) : Color("SecondaryColor"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isCurrent ? Color("PrimaryColor") : Color("ThirdColor"), lineWidth: isCurrent ? 2 : 1)
                )
            
            HStack {
                Text(team.name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(team.score) Puan")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isCurrent ? Color("PrimaryColor") : .white)
            }
            .padding(20)
        }
    }
}
