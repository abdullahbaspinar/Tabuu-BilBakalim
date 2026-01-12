//
//  Team.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import Foundation

struct Team: Identifiable, Codable {
    let id: UUID
    var name: String
    var score: Int
    
    init(id: UUID = UUID(), name: String, score: Int = 0) {
        self.id = id
        self.name = name
        self.score = score
    }
}

