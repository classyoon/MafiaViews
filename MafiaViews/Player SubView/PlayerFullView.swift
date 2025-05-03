//
//  PlayerFullView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//

import SwiftUI

struct PlayerFullView: View {
    var player: Player
    var showRole: Bool = false
    var isDead: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                // PlayerView
                VStack {
                    ZStack {
                        PlayerView(player: player.name)
                            .opacity(isDead ? 0.6 : 1.0)
                        
                        if isDead {
                            Image(systemName: "xmark")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.7))
                                        .frame(width: 40, height: 40)
                                )
                        }
                    }
                    
                    if showRole {
                        Text(player.role.rawValue.capitalized)
                            .font(.caption)
                            .foregroundColor(player.role == .mafia ? .red : .blue)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                    }
                }
                .padding(.vertical, 5)
                
                // Status indicator for night actions (visible only to certain roles)
                if !isDead && showRole {
                    Image(systemName: player.hasActed ? "checkmark.circle.fill" : "hourglass")
                        .foregroundColor(player.hasActed ? .green : .orange)
                        .font(.title2)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
        }
    }
}

#Preview {
    PlayerFullView(player: Player("Johnson"))
}
