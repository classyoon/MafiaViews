//
//  TransitionViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


import Foundation
// Transition view model
class TransitionViewModel: ObservableObject {
    private let gameManager = GameManager.shared
    
    @Published var gameTime: GameLabelState
    @Published var message: String = ""
    @Published var isFirstNight: Bool = false
    
    init() {
        self.gameTime = gameManager.game.time
        self.isFirstNight = gameManager.isFirstNight
        
        // Set message based on game state
        if gameTime == .dawn {
            if let lastExecuted = gameManager.game.lastExecuted,
               let player = gameManager.game.players.first(where: { $0.id == lastExecuted }) {
                message = "\(player.name) was executed by the town."
            } else {
                message = "Nobody was executed today."
            }
        } else if gameTime == .dusk {
            if isFirstNight {
                message = "Night falls for the first time. The Mafia is on the move."
            } else {
                let killedPlayers = gameManager.game.players.filter {
                    $0.isDead && gameManager.game.lastExecuted != $0.id
                }
                
                if killedPlayers.isEmpty {
                    message = "Everyone survived the night."
                } else if killedPlayers.count == 1 {
                    message = "\(killedPlayers[0].name) was killed during the night."
                } else {
                    let names = killedPlayers.map { $0.name }.joined(separator: ", ")
                    message = "\(names) were killed during the night."
                }
            }
        }
    }
    
    func continueGame() {
        gameManager.advancePhase()
    }
}
