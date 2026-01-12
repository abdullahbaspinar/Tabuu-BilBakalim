//
//  GameSettings.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import Foundation

struct GameSettings {
    var duration: Int // seconds (30-180)
    var passLimit: Int // 0-10
    var winScore: Int // 5-100
    
    init(duration: Int = 90, passLimit: Int = 3, winScore: Int = 30) {
        self.duration = duration
        self.passLimit = passLimit
        self.winScore = winScore
    }
}

struct RoundStats {
    var correctCount: Int = 0
    var wrongCount: Int = 0
    var passCount: Int = 0
    
    var roundScore: Int {
        correctCount - wrongCount
    }
}

