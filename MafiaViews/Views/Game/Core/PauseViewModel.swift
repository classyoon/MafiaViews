//
//  PauseViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


import Foundation
class PauseViewModel: ObservableObject, GameStateObserver {
    private let gameManager = GameManager.shared
    
    @Published var players: [Player] = []
    @Published var currentPlayerName: String = ""
    @Published var navigateToMenu = false
    @Published var resumeGame = false
    
    init() {
        gameManager.addObserver(self)
        self.players = gameManager.game.players
        updateCurrentPlayer()
    }
    
    deinit {
        gameManager.removeObserver(self)
    }
    
    func gameStateDidChange(_ game: Game) {
        DispatchQueue.main.async {
            self.players = game.players
            self.updateCurrentPlayer()
        }
    }
    
    private func updateCurrentPlayer() {
        if let currentPhase = gameManager.pausedPhase {
            switch currentPhase {
            case .night, .day:
                if let currentPlayerId = gameManager.currentPlayerId,
                   let player = players.first(where: { $0.id == currentPlayerId }) {
                    currentPlayerName = player.name
                } else {
                    currentPlayerName = "next player"
                }
            default:
                currentPlayerName = "next player"
            }
        } else {
            currentPlayerName = "next player"
        }
    }
    
    func resume() {
        gameManager.resumeGame()
        resumeGame = true
    }
    
    func goToMainMenu() {
        navigateToMenu = true
    }
    
    func restartGame() {
        // First navigate to menu to avoid transition issues
        navigateToMenu = true
        // Then reset game
        gameManager.resetGame()
    }
}
