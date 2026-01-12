//
//  LeaderboardCardView.swift
//  Tabuu-BilBakalim
//
//  Created by Abdullah B on 11.01.2026.
//

import SwiftUI

struct LeaderboardCardView: View {
    let teams: [Team]
    var currentTeamIndex: Int = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("SecondaryColor"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("ThirdColor"), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Tüm Takımlar")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                ForEach(Array(teams.enumerated()), id: \.element.id) { index, team in
                    HStack {
                        Text("\(index + 1).")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("ThirdColor"))
                            .frame(width: 30)
                        
                        Text(team.name)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(team.score)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    
                    if index < teams.count - 1 {
                        Divider()
                            .background(Color("ThirdColor").opacity(0.5))
                    }
                }
            }
            .padding(20)
        }
    }
}

