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
        [
            GameCard(mainWord: "Köpek", forbiddenWords: ["Hayvan", "Hav", "Pat", "Kuyruk"]),
            GameCard(mainWord: "Bilgisayar", forbiddenWords: ["Ekran", "Klavye", "Mouse", "İnternet"]),
            GameCard(mainWord: "Pizza", forbiddenWords: ["Yemek", "Peynir", "Domates", "İtalya"]),
            GameCard(mainWord: "Uçak", forbiddenWords: ["Hava", "Yolcu", "Pilot", "Gökyüzü"]),
            GameCard(mainWord: "Kitap", forbiddenWords: ["Okumak", "Sayfa", "Yazar", "Kütüphane"]),
            GameCard(mainWord: "Müzik", forbiddenWords: ["Ses", "Şarkı", "Enstrüman", "Kulaklık"]),
            GameCard(mainWord: "Deniz", forbiddenWords: ["Su", "Dalga", "Kum", "Balık"]),
            GameCard(mainWord: "Araba", forbiddenWords: ["Tekerlek", "Motor", "Direksiyon", "Yol"]),
            GameCard(mainWord: "Telefon", forbiddenWords: ["Arama", "Ekran", "Kamera", "Mesaj"]),
            GameCard(mainWord: "Kahve", forbiddenWords: ["İçecek", "Sıcak", "Fincan", "Kafein"]),
            GameCard(mainWord: "Güneş", forbiddenWords: ["Gökyüzü", "Sıcak", "Işık", "Gündüz"]),
            GameCard(mainWord: "Ay", forbiddenWords: ["Gece", "Yıldız", "Gökyüzü", "Işık"]),
            GameCard(mainWord: "Yıldız", forbiddenWords: ["Gece", "Gökyüzü", "Parlak", "Uzak"]),
            GameCard(mainWord: "Çiçek", forbiddenWords: ["Kokulu", "Bahçe", "Renk", "Yaprak"]),
            GameCard(mainWord: "Ağaç", forbiddenWords: ["Yaprak", "Dal", "Orman", "Doğa"]),
            GameCard(mainWord: "Ev", forbiddenWords: ["Kapı", "Pencere", "Oda", "Aile"]),
            GameCard(mainWord: "Okul", forbiddenWords: ["Öğrenci", "Öğretmen", "Ders", "Sıra"]),
            GameCard(mainWord: "Hastane", forbiddenWords: ["Doktor", "Hasta", "İlaç", "Ameliyat"]),
            GameCard(mainWord: "Spor", forbiddenWords: ["Futbol", "Koşmak", "Takım", "Yarış"]),
            GameCard(mainWord: "Müze", forbiddenWords: ["Tarih", "Eser", "Sergi", "Ziyaret"]),
            GameCard(mainWord: "Sinema", forbiddenWords: ["Film", "Koltuk", "Ekran", "Patlamış Mısır"]),
            GameCard(mainWord: "Restoran", forbiddenWords: ["Yemek", "Garson", "Masa", "Menü"]),
            GameCard(mainWord: "Alışveriş", forbiddenWords: ["Para", "Mağaza", "Sepet", "İndirim"]),
            GameCard(mainWord: "Tatil", forbiddenWords: ["Deniz", "Güneş", "Dinlenmek", "Yolculuk"]),
            GameCard(mainWord: "Doğum Günü", forbiddenWords: ["Pasta", "Hediya", "Mum", "Kutlama"]),
            GameCard(mainWord: "Düğün", forbiddenWords: ["Gelin", "Damat", "Pasta", "Dans"]),
            GameCard(mainWord: "İş", forbiddenWords: ["Ofis", "Toplantı", "Maaş", "Patron"]),
            GameCard(mainWord: "Arkadaş", forbiddenWords: ["Birlikte", "Konuşmak", "Eğlence", "Yardım"]),
            GameCard(mainWord: "Aile", forbiddenWords: ["Anne", "Baba", "Çocuk", "Ev"]),
            GameCard(mainWord: "Sevgili", forbiddenWords: ["Aşk", "Romantik", "Öpücük", "İlişki"]),
            GameCard(mainWord: "Şehir", forbiddenWords: ["Bina", "Cadde", "İnsan", "Büyük"]),
            GameCard(mainWord: "Köy", forbiddenWords: ["Küçük", "Doğa", "Sakin", "Tarım"]),
            GameCard(mainWord: "Dağ", forbiddenWords: ["Yüksek", "Tırmanmak", "Kar", "Zirve"]),
            GameCard(mainWord: "Nehir", forbiddenWords: ["Su", "Akış", "Köprü", "Balık"]),
            GameCard(mainWord: "Göl", forbiddenWords: ["Su", "Sakin", "Yansıma", "Kıyı"]),
            GameCard(mainWord: "Orman", forbiddenWords: ["Ağaç", "Yeşil", "Hayvan", "Doğa"]),
            GameCard(mainWord: "Çöl", forbiddenWords: ["Kum", "Sıcak", "Kaktüs", "Su Yok"]),
            GameCard(mainWord: "Kar", forbiddenWords: ["Beyaz", "Soğuk", "Kardan Adam", "Kayak"]),
            GameCard(mainWord: "Yağmur", forbiddenWords: ["Su", "Bulut", "Şemsiye", "Islak"]),
            GameCard(mainWord: "Rüzgar", forbiddenWords: ["Hava", "Esinti", "Sallanmak", "Soğuk"]),
            GameCard(mainWord: "Fırtına", forbiddenWords: ["Rüzgar", "Yağmur", "Gök Gürültüsü", "Şimşek"]),
            GameCard(mainWord: "Gökkuşağı", forbiddenWords: ["Renk", "Yağmur", "Gökyüzü", "7 Renk"]),
            GameCard(mainWord: "Parmak", forbiddenWords: ["El", "5", "Tırnak", "Dokunmak"]),
            GameCard(mainWord: "Ayak", forbiddenWords: ["Yürümek", "Ayakkabı", "Parmak", "Bacak"]),
            GameCard(mainWord: "Kulak", forbiddenWords: ["Duymak", "İki", "Küpe", "Ses"]),
            GameCard(mainWord: "Burun", forbiddenWords: ["Koku", "İki Delik", "Yüz", "Nefes"]),
            GameCard(mainWord: "Göz", forbiddenWords: ["Görmek", "İki", "Gözlük", "Renk"]),
            GameCard(mainWord: "Ağız", forbiddenWords: ["Konuşmak", "Yemek", "Diş", "Dil"]),
            GameCard(mainWord: "Kalp", forbiddenWords: ["Sevgi", "Atış", "Kırmızı", "Organ"]),
            GameCard(mainWord: "Beyin", forbiddenWords: ["Düşünmek", "Akıllı", "Kafatası", "Hafıza"]),
            GameCard(mainWord: "El", forbiddenWords: ["5 Parmak", "Tutmak", "Yazmak", "Sallamak"]),
            GameCard(mainWord: "Bacak", forbiddenWords: ["Yürümek", "Koşmak", "İki", "Pantolon"])
        ]
    }
}

