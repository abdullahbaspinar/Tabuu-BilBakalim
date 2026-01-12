//
//  GameViewModel.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class GameViewModel: ObservableObject {
    // Teams
    @Published var teams: [Team] = [
        Team(name: "1. Takım"),
        Team(name: "2. Takım")
    ]
    
    // Settings
    @Published var gameSettings = GameSettings()
    
    // Game State
    @Published var currentTeamIndex: Int = 0
    @Published var currentRoundStats = RoundStats()
    @Published var cards: [GameCard] = []
    @Published var currentCardIndex: Int = 0
    @Published var usedPassCount: Int = 0
    
    // Timer
    @Published var timeRemaining: Int = 90
    @Published var isTimerRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var shouldShowChangeScreen: Bool = false
    @Published var shouldShowGameOver: Bool = false
    
    private var timer: Timer?
    
    var currentTeam: Team {
        guard currentTeamIndex < teams.count else {
            return teams[0]
        }
        return teams[currentTeamIndex]
    }
    
    var currentCard: GameCard? {
        guard currentCardIndex < cards.count else {
            return nil
        }
        return cards[currentCardIndex]
    }
    
    var isGameOver: Bool {
        teams.contains { $0.score >= gameSettings.winScore }
    }
    
    var winningTeam: Team? {
        teams.first { $0.score >= gameSettings.winScore }
    }
    
    init() {
        shuffleCards()
    }
    
    func shuffleCards() {
        cards = GameCard.dummyCards.shuffled()
        currentCardIndex = 0
    }
    
    func addTeam() {
        let teamNumber = teams.count + 1
        teams.append(Team(name: "\(teamNumber). Takım"))
    }
    
    func removeTeam(_ team: Team) {
        guard teams.count > 2 else { return } // Minimum 2 takım
        if let index = teams.firstIndex(where: { $0.id == team.id }) {
            teams.remove(at: index)
            // Eğer silinen takım currentTeamIndex'ten önceyse, index'i ayarla
            if index <= currentTeamIndex && currentTeamIndex > 0 {
                currentTeamIndex -= 1
            }
            // Eğer currentTeamIndex silinen takım ise, bir önceki takıma geç
            if currentTeamIndex >= teams.count {
                currentTeamIndex = teams.count - 1
            }
        }
    }
    
    func updateTeamName(_ team: Team, newName: String) {
        if let index = teams.firstIndex(where: { $0.id == team.id }) {
            teams[index].name = newName
        }
    }
    
    func startGame() {
        shuffleCards()
        currentTeamIndex = 0
        startRound()
    }
    
    func startRound() {
        currentRoundStats = RoundStats()
        usedPassCount = 0
        timeRemaining = gameSettings.duration
        isTimerRunning = true
        isPaused = false
        startTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, !self.isPaused else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.endRound()
                }
            }
        }
    }
    
    func pauseGame() {
        isPaused = true
        isTimerRunning = false
        timer?.invalidate()
    }
    
    func resumeGame() {
        isPaused = false
        isTimerRunning = true
        startTimer()
    }
    
    func endRound() {
        timer?.invalidate()
        isTimerRunning = false
        
        // Update team score: each correct = +1, each wrong = -1
        if currentTeamIndex < teams.count {
            let scoreChange = currentRoundStats.correctCount - currentRoundStats.wrongCount
            teams[currentTeamIndex].score += scoreChange
            // Ensure score doesn't go below 0
            if teams[currentTeamIndex].score < 0 {
                teams[currentTeamIndex].score = 0
            }
        }
        
        // Check if game is over
        if isGameOver {
            shouldShowGameOver = true
        } else {
            shouldShowChangeScreen = true
        }
    }
    
    func nextTeam() {
        currentTeamIndex = (currentTeamIndex + 1) % teams.count
    }
    
    func handleCorrect() {
        currentRoundStats.correctCount += 1
        nextCard()
    }
    
    func handleWrong() {
        currentRoundStats.wrongCount += 1
        nextCard()
    }
    
    func handlePass() {
        guard usedPassCount < gameSettings.passLimit else {
            return
        }
        usedPassCount += 1
        currentRoundStats.passCount += 1
        nextCard()
    }
    
    func nextCard() {
        currentCardIndex += 1
        
        // If we run out of cards, reshuffle
        if currentCardIndex >= cards.count {
            shuffleCards()
        }
    }
    
    func resetGame() {
        timer?.invalidate()
        // Reset teams but keep game settings
        teams = teams.map { Team(id: $0.id, name: $0.name, score: 0) }
        // Don't reset gameSettings - keep previous settings
        currentTeamIndex = 0
        currentRoundStats = RoundStats()
        timeRemaining = gameSettings.duration
        isTimerRunning = false
        isPaused = false
        usedPassCount = 0
        shouldShowChangeScreen = false
        shouldShowGameOver = false
        shuffleCards()
    }
    
    func restartGame() {
        resetGame()
        startGame()
    }
    
    func continueToNextTeam() {
        shouldShowChangeScreen = false
        nextTeam()
    }
}

