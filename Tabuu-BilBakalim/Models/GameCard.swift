//
//  GameCard.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import Foundation

struct GameCard: Identifiable, Codable {
    let id: UUID
    let mainWord: String
    let forbiddenWords: [String]
    
    init(id: UUID = UUID(), mainWord: String, forbiddenWords: [String]) {
        self.id = id
        self.mainWord = mainWord
        self.forbiddenWords = forbiddenWords
    }
}

extension GameCard {
    static var dummyCards: [GameCard] {
        loadCardsFromJSON()
    }
    
    private static func loadCardsFromJSON() -> [GameCard] {
        guard let url = Bundle.main.url(forResource: "tabu_words", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            // Eğer JSON yüklenemezse, varsayılan kartları döndür
            return fallbackCards()
        }
        
        var cards: [GameCard] = []
        for item in jsonArray {
            if let mainWord = item["mainWord"] as? String,
               let forbiddenWords = item["forbiddenWords"] as? [String] {
                cards.append(GameCard(mainWord: mainWord, forbiddenWords: forbiddenWords))
            }
        }
        
        return cards.isEmpty ? fallbackCards() : cards
    }
    
    private static func fallbackCards() -> [GameCard] {
        [
            GameCard(mainWord: "Erteleme", forbiddenWords: ["Sonra", "Yarın", "Geç", "Zaman", "Tembel"]),
            GameCard(mainWord: "Dedikodu", forbiddenWords: ["Konuşmak", "Başkası", "Söylemek", "Arkadan", "Fısıldamak"])
        ]
    }
}

