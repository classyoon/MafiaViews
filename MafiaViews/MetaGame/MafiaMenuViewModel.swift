//
//  ViewModels.swift
//  MafiaViews
//
//  Created on 5/2/25.
//

import Foundation
import SwiftUI
import Combine

// Main menu view model
class MafiaMenuViewModel: ObservableObject {
    @Published var navigateToSetup = false
    @Published var navigateToCredits = false
    @Published var navigateToStore = false
    
    func startGame() {
        navigateToSetup = true
    }
    
    func showCredits() {
        navigateToCredits = true
    }
    
    func showStore() {
        navigateToStore = true
    }
}

// Setup game view model
class SetUpGameViewModel: ObservableObject, GameStateObserver {
    private let gameManager = GameManager.shared
    
    @Published var players: [Player] = []
    @Published var mafiaCount: Int = 1
    @Published var doctorCount: Int = 0
    @Published var detectiveCount: Int = 0
    @Published var navigateToGame = false
    @Published var navigateToMainMenu = false
    @Published var playerName: String = ""
    @Published var showRoleCounts: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // Computed properties for validation
    var maxMafia: Int {
        max(1, players.count / 3) // Maximum 1/3 of players can be mafia
    }
    
    var maxSpecialRoles: Int {
        max(1, players.count - 2) // At least 2 townspeople
    }
    
    var canIncrementMafia: Bool {
        mafiaCount < maxMafia && mafiaCount + doctorCount + detectiveCount < maxSpecialRoles
    }
    
    var canIncrementDoctor: Bool {
        doctorCount < 2 && mafiaCount + doctorCount + detectiveCount < maxSpecialRoles
    }
    
    var canIncrementDetective: Bool {
        detectiveCount < 2 && mafiaCount + doctorCount + detectiveCount < maxSpecialRoles
    }
    
    var minPlayers: Int {
        return 4 // Minimum needed for a basic game
    }
    
    var hasMinimumPlayers: Bool {
        return players.count >= minPlayers
    }
    
    init() {
        gameManager.addObserver(self)
        self.players = gameManager.game.players
        
        // Auto-populate with minimum players if empty
        if players.isEmpty {
            populateWithDefaultPlayers(count: minPlayers)
        }
    }
    
    deinit {
        gameManager.removeObserver(self)
    }
    
    func gameStateDidChange(_ game: Game) {
        // Ensure UI updates happen on the main thread
        DispatchQueue.main.async {
            self.players = game.players
        }
    }
    
    func addPlayer() {
        guard !playerName.isEmpty else { return }
        _ = gameManager.addPlayer(name: playerName)
        playerName = ""
    }
    
    func addQuickPlayer() {
        let newName = "Player \(players.count + 1)"
        _ = gameManager.addPlayer(name: newName)
    }
    
    func populateWithDefaultPlayers(count: Int) {
        gameManager.populateWithDefaultPlayers(count: count)
        defaultRoles() // Set default roles for the new players
    }
    
    func removePlayer(_ player: Player) {
        gameManager.removePlayer(player)
        
        // Adjust role counts if they exceed the new player count
        if mafiaCount > maxMafia {
            mafiaCount = maxMafia
        }
        
        if mafiaCount + doctorCount + detectiveCount > maxSpecialRoles {
            // Prioritize keeping mafia, then reduce doctors/detectives
            if doctorCount > 0 {
                doctorCount -= 1
            } else if detectiveCount > 0 {
                detectiveCount -= 1
            }
        }
    }
    
    func defaultRoles() {
        gameManager.setDefaultRoles()
        updateRoleCounts()
    }
    
    func randomRoles() {
        gameManager.setRandomRoles()
        updateRoleCounts()
    }
    
    func mysteryRoles() {
        // Use random roles but don't reveal the counts
        gameManager.setRandomRoles()
        showRoleCounts = false
    }
    
    func startGame() {
        if !hasMinimumPlayers {
            errorMessage = "Need at least \(minPlayers) players to start"
            showError = true
            return
        }
        
        if showRoleCounts {
            gameManager.assignRoles(mafia: mafiaCount, doctors: doctorCount, detectives: detectiveCount)
        }
        // If not showing role counts, we already assigned them with mystery/random roles
        
        gameManager.startGame()
        navigateToGame = true
    }
    
    func incrementMafia() {
        if canIncrementMafia {
            mafiaCount += 1
        } else {
            errorMessage = "Maximum mafia count reached (1/3 of players)"
            showError = true
        }
    }
    
    func decrementMafia() {
        if mafiaCount > 1 {
            mafiaCount -= 1
        } else {
            errorMessage = "At least one mafia member is required"
            showError = true
        }
    }
    
    func incrementDoctor() {
        if canIncrementDoctor {
            doctorCount += 1
        } else {
            errorMessage = "Cannot add more special roles"
            showError = true
        }
    }
    
    func decrementDoctor() {
        if doctorCount > 0 {
            doctorCount -= 1
        }
    }
    
    func incrementDetective() {
        if canIncrementDetective {
            detectiveCount += 1
        } else {
            errorMessage = "Cannot add more special roles"
            showError = true
        }
    }
    
    func decrementDetective() {
        if detectiveCount > 0 {
            detectiveCount -= 1
        }
    }
    
    func updateRoleCounts() {
        mafiaCount = players.filter { $0.role == .mafia }.count
        doctorCount = players.filter { $0.role == .doctor }.count
        detectiveCount = players.filter { $0.role == .detective }.count
        showRoleCounts = true
    }
}



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

// Update GameManager.swift to add isFirstNight functionality
// Add this property and method to the GameManager class

extension GameManager {
    var isFirstNight: Bool {
        // Consider it the first night if we're in the first night transition and no players are dead
        return currentPhase == .nightTransition && !game.players.contains(where: { $0.isDead })
    }
}

// Confirmation vote view model
class ConfirmVoteViewModel: ObservableObject {
    var playerName: String
    var action: String
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    init(playerName: String, action: String, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.playerName = playerName
        self.action = action
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    func confirm() {
        onConfirm()
    }
    
    func cancel() {
        onCancel()
    }
}
