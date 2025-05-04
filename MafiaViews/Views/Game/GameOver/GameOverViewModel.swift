//
//  GameOverViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


import Foundation
// Game over view model
class GameOverViewModel: ObservableObject {
    private let gameManager = GameManager.shared
    
    @Published var winner: TeamText?
    @Published var players: [Player] = []
    @Published var navigateToMenu = false
    @Published var navigateToNewGame = false
    
    init() {
        self.winner = gameManager.game.winner
        self.players = gameManager.game.players
    }
    
    func playAgain() {
        let oldPlayers = gameManager.game.players.map {
            var player = $0
            player.isDead = false
            player.hasActed = false
            player.target = nil
            player.notes = ""
            return player
        }
        
        gameManager.resetGame()
        
        // Restore players without their state
        for player in oldPlayers {
            _ = gameManager.addPlayer(name: player.name)
        }
        
        navigateToNewGame = true
    }
    
    func goToMenu() {
        gameManager.resetGame()
        navigateToMenu = true
    }
    
    func playDifferent() {
        gameManager.resetGame()
        navigateToNewGame = true
    }
}