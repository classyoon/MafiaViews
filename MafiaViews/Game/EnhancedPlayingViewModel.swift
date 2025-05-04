//
//  EnhancedPlayingViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//

import Foundation
// Playing view model that extends your existing PlayingViewModel
class EnhancedPlayingViewModel: ObservableObject, GameStateObserver {
    let gameManager = GameManager.shared
    
    @Published var game: Game
    @Published var currentPlayerIndex: Int = 0
    @Published var currentPlayer: Player?
    @Published var otherPlayers: [Player] = []
    @Published var selectedPlayer: Player?
    @Published var showConfirmation = false
    @Published var showTransition = false
    @Published var gameEnded = false
    
    // Previous properties for compatibility
    var time: GameLabelState {
        game.time
    }
    
    var timeText: String {
        game.time.rawValue
    }
    
    var roleText: String {
        currentPlayer?.team.rawValue ?? "No TEAM"
    }
    
    var instructions: String {
        guard let player = currentPlayer else { return "No TEAM Text" }
        
        switch player.role {
        case .mafia:
            return "Kill off the townsfolk without being caught"
        case .detective, .doctor, .townsperson:
            return "Catch the mafia before they kill everyone"
        }
    }
    
    var rolePowers: String {
        if game.time == .day {
            return "Pick someone to vote to eliminate or abstain."
        }
        else {
            guard let role = currentPlayer?.role else { return "No action" }
            switch role {
            case .mafia:
                return "Whoever you pick, you will kill unless they are saved"
            case .townsperson:
                return "You have no powers. Visiting has no affect."
            case .detective:
                return "Whoever you pick you learn the role of"
            case .doctor:
                return "Whoever you pick you will be protected"
            }
        }
    }
    
    var actionText: String {
        if game.time == .day {
            return "Vote"
        } else {
            guard let role = currentPlayer?.role else { return "No action text" }
            switch role {
            case .mafia:
                return "Kill"
            case .townsperson:
                return "Visit"
            case .detective:
                return "Investigate"
            case .doctor:
                return "Protect"
            }
        }
    }
    
    init() {
        self.game = gameManager.game
        gameManager.addObserver(self)
        updateCurrentPlayer()
    }
    
    deinit {
        gameManager.removeObserver(self)
    }
    
    func gameStateDidChange(_ game: Game) {
        self.game = game
        
        if gameManager.gameState == .ended {
            gameEnded = true
        } else if gameManager.currentPhase == .dayTransition || gameManager.currentPhase == .nightTransition {
            showTransition = true
        } else {
            showTransition = false
            updateCurrentPlayer()
        }
    }
    
    func updateCurrentPlayer() {
        let livingPlayers = game.players.filter { !$0.isDead }
        
        if currentPlayerIndex >= livingPlayers.count {
            currentPlayerIndex = 0
        }
        
        if !livingPlayers.isEmpty {
            currentPlayer = livingPlayers[currentPlayerIndex]
            otherPlayers = livingPlayers.filter { $0.id != currentPlayer?.id }
        } else {
            currentPlayer = nil
            otherPlayers = []
        }
    }
    
    func selectPlayer(_ player: Player) {
        selectedPlayer = player
    }
    
    func confirmAction() {
        guard let current = currentPlayer, let target = selectedPlayer else { return }
        
        gameManager.playerSelect(currentPlayer: current, target: target)
        showConfirmation = false
        selectedPlayer = nil
        
        // Move to next player
        currentPlayerIndex += 1
        if currentPlayerIndex >= game.livingPlayers().count {
            currentPlayerIndex = 0
        }
        
        updateCurrentPlayer()
    }
    
    func skipAction() {
        guard let current = currentPlayer else { return }
        
        gameManager.skipAction(for: current)
        selectedPlayer = nil
        
        // Move to next player
        currentPlayerIndex += 1
        if currentPlayerIndex >= game.livingPlayers().count {
            currentPlayerIndex = 0
        }
        
        updateCurrentPlayer()
    }
    
    func dismissTransition() {
        showTransition = false
    }
    
    func updateNotes(text: String) {
        guard let index = game.players.firstIndex(where: { $0.id == currentPlayer?.id }) else { return }
        gameManager.game.players[index].notes = text
    }
}
