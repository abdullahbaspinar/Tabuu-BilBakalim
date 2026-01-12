//
//  GameSetupView.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

struct GameSetupView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var editingTeam: Team?
    @State private var teamNameText = ""
    @State private var showTeamNameAlert = false
    
    var body: some View {
        ZStack {
            Color("FourthColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Teams Section
                    VStack(spacing: 16) {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(viewModel.teams) { team in
                                TeamCard(
                                    team: team,
                                    canDelete: viewModel.teams.count > 2,
                                    onTap: {
                                        editingTeam = team
                                        teamNameText = team.name
                                        showTeamNameAlert = true
                                    },
                                    onDelete: {
                                        viewModel.removeTeam(team)
                                    }
                                )
                            }
                        }
                        
                        Button(action: {
                            viewModel.addTeam()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color("SecondaryColor"))
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Settings Section
                    VStack(spacing: 20) {
                        // Duration
                        SettingsCard {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Süre")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(viewModel.gameSettings.duration) sn")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(Color("PrimaryColor"))
                                }
                                
                                Slider(
                                    value: Binding(
                                        get: { Double(viewModel.gameSettings.duration) },
                                        set: { viewModel.gameSettings.duration = Int($0) }
                                    ),
                                    in: 30...180,
                                    step: 10
                                )
                                .tint(Color("PrimaryColor"))
                            }
                        }
                        
                        // Pass Limit
                        SettingsCard {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Pas Hakkı")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(viewModel.gameSettings.passLimit)")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(Color("PrimaryColor"))
                                }
                                
                                Slider(
                                    value: Binding(
                                        get: { Double(viewModel.gameSettings.passLimit) },
                                        set: { viewModel.gameSettings.passLimit = Int($0) }
                                    ),
                                    in: 0...10,
                                    step: 1
                                )
                                .tint(Color("PrimaryColor"))
                            }
                        }
                        
                        // Win Score
                        SettingsCard {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Kazanma Puanı")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(viewModel.gameSettings.winScore)")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(Color("PrimaryColor"))
                                }
                                
                                Slider(
                                    value: Binding(
                                        get: { Double(viewModel.gameSettings.winScore) },
                                        set: { viewModel.gameSettings.winScore = Int($0) }
                                    ),
                                    in: 5...100,
                                    step: 5
                                )
                                .tint(Color("PrimaryColor"))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Start Button
                    NavigationLink(destination: GameScreenView(viewModel: viewModel)) {
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
        .navigationTitle("Oyun Kurulumu")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Takım Adı", isPresented: $showTeamNameAlert) {
            TextField("Takım adı", text: $teamNameText)
            Button("İptal", role: .cancel) {}
            Button("Kaydet") {
                if let team = editingTeam {
                    viewModel.updateTeamName(team, newName: teamNameText)
                }
            }
        } message: {
            Text("Takım adını girin")
        }
    }
}

struct TeamCard: View {
    let team: Team
    let canDelete: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("SecondaryColor"))
                .frame(height: 80)
            
            HStack {
                Button(action: onTap) {
                    Text(team.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if canDelete {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("PrimaryColor"))
                            .padding(8)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("SecondaryColor"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("ThirdColor"), lineWidth: 1)
                )
            
            content
                .padding(20)
        }
    }
}

