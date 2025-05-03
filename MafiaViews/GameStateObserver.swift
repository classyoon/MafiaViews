//
//  GameManager.swift
//  MafiaViews
//
//  Created on 5/2/25.
//

import Foundation
import SwiftUI
import Combine

// Protocol for observer pattern to notify changes in game state
protocol GameStateObserver: AnyObject {
    func gameStateDidChange(_ game: Game)
}

// Main class to handle game logic
class GameManager: ObservableObject {
    // Singleton instance
    static let shared = GameManager()
    
    @Published var game: Game = Game()
    @Published var gameState: PlayerStage = .start
    @Published var currentPhase: GamePhase = .setup
    
    private var observers = [GameStateObserver]()
    
    private init() {}
    
    // MARK: - Game Setup
    
    func createGame(players: [Player]) {
        game = Game()
        game.players = players
        game.time = .dusk // Start with dusk to transition to night
        gameState = .playing
        currentPhase = .nightTransition
        
        // Notify all observers
        notifyObservers()
    }
    
    func addPlayer(name: String) -> Player {
        let player = Player(name)
        game.players.append(player)
        notifyObservers()
        return player
    }
    
    func removePlayer(_ player: Player) {
        game.players.removeAll { $0.id == player.id }
        notifyObservers()
    }
    
    func assignRoles(mafia: Int, doctors: Int, detectives: Int) {
        guard mafia + doctors + detectives <= game.players.count else {
            print("Error: Too many special roles for player count")
            return
        }
        
        // Reset all roles
        for i in 0..<game.players.count {
            game.players[i].role = .townsperson
        }
        
        // Shuffle players for random assignment
        var indices = Array(0..<game.players.count)
        indices.shuffle()
        
        // Assign mafia
        for i in 0..<mafia {
            if i < indices.count {
                game.players[indices[i]].role = .mafia
            }
        }
        
        // Assign doctors
        for i in mafia..<(mafia + doctors) {
            if i < indices.count {
                game.players[indices[i]].role = .doctor
            }
        }
        
        // Assign detectives
        for i in (mafia + doctors)..<(mafia + doctors + detectives) {
            if i < indices.count {
                game.players[indices[i]].role = .detective
            }
        }
    }
    
    func setDefaultRoles() {
        let playerCount = game.players.count
        var mafia = max(1, playerCount / 4)
        var doctors = (playerCount >= 6) ? 1 : 0
        var detectives = (playerCount >= 7) ? 1 : 0
        
        if playerCount >= 9 {
            mafia = playerCount / 3
            doctors = 1
            detectives = 1
        }
        
        assignRoles(mafia: mafia, doctors: doctors, detectives: detectives)
    }
    
    func setRandomRoles() {
        let playerCount = game.players.count
        let mafia = max(1, Int.random(in: playerCount/5...playerCount/3))
        let doctors = (playerCount >= 6) ? Int.random(in: 0...1) : 0
        let detectives = (playerCount >= 7) ? Int.random(in: 0...1) : 0
        
        assignRoles(mafia: mafia, doctors: doctors, detectives: detectives)
    }
    
    // MARK: - Game Flow
    
    func startGame() {
        gameState = .playing
        currentPhase = .nightTransition
        advancePhase()
    }
    
    func advancePhase() {
        switch currentPhase {
        case .setup:
            currentPhase = .nightTransition
            game.time = .dusk
            
        case .nightTransition:
            currentPhase = .night
            game.time = .night
            resetPlayerActions()
            
        case .night:
            // Process night actions
            processNightActions()
            currentPhase = .dayTransition
            game.time = .dawn
            
        case .dayTransition:
            currentPhase = .day
            game.time = .day
            resetPlayerActions()
            
        case .day:
            // Process day voting
            processDayVoting()
            currentPhase = .nightTransition
            game.time = .dusk
            
        case .endGame:
            gameState = .ended
        }
        
        // Check winning conditions
        checkWinningConditions()
        
        // Notify all observers
        notifyObservers()
    }
    
    private func resetPlayerActions() {
        for i in 0..<game.players.count {
            game.players[i].target = nil
            game.players[i].hasActed = false
        }
    }
    
    private func checkWinningConditions() {
        let alivePlayers = game.players.filter { !$0.isDead }
        let aliveMafia = alivePlayers.filter { $0.role == .mafia }
        let aliveTownspeople = alivePlayers.filter { $0.role != .mafia }
        
        if aliveMafia.isEmpty {
            game.winner = .townsfolk
            currentPhase = .endGame
            gameState = .ended
        } else if aliveMafia.count >= aliveTownspeople.count {
            game.winner = .mafia
            currentPhase = .endGame
            gameState = .ended
        }
    }
    
    // MARK: - Game Actions
    
    func playerSelect(currentPlayer: Player, target: Player) {
        guard let playerIndex = game.players.firstIndex(where: { $0.id == currentPlayer.id }),
              !currentPlayer.isDead else { return }
        
        game.players[playerIndex].target = target.id
        game.players[playerIndex].hasActed = true
        
        // Check if all players have acted
        checkAllPlayersActed()
    }
    
    func skipAction(for player: Player) {
        guard let playerIndex = game.players.firstIndex(where: { $0.id == player.id }),
              !player.isDead else { return }
        
        game.players[playerIndex].hasActed = true
        
        // Check if all players have acted
        checkAllPlayersActed()
    }
    
    private func checkAllPlayersActed() {
        let relevantPlayers = game.players.filter { !$0.isDead }
        let allActed = relevantPlayers.allSatisfy { $0.hasActed }
        
        if allActed {
            advancePhase()
        }
    }
    
    private func processNightActions() {
        var protectedPlayers = Set<UUID>()
        var investigatedPlayers = [UUID: RoleText]()
        var killedPlayers = Set<UUID>()
        
        // Process doctor protections first
        for player in game.players where player.role == .doctor && !player.isDead {
            if let targetId = player.target {
                protectedPlayers.insert(targetId)
            }
        }
        
        // Process detective investigations
        for player in game.players where player.role == .detective && !player.isDead {
            if let targetId = player.target,
               let targetPlayer = game.players.first(where: { $0.id == targetId }) {
                investigatedPlayers[player.id] = targetPlayer.role
            }
        }
        
        // Process mafia kills
        for player in game.players where player.role == .mafia && !player.isDead {
            if let targetId = player.target, !protectedPlayers.contains(targetId) {
                killedPlayers.insert(targetId)
            }
        }
        
        // Apply kills
        for i in 0..<game.players.count {
            if killedPlayers.contains(game.players[i].id) {
                game.players[i].isDead = true
            }
        }
        
        // Save investigation results
        game.investigationResults = investigatedPlayers
    }
    
    private func processDayVoting() {
        // Count votes
        var voteCount = [UUID: Int]()
        
        for player in game.players where !player.isDead {
            if let targetId = player.target {
                voteCount[targetId, default: 0] += 1
            }
        }
        
        // Find most voted player
        var maxVotes = 0
        var maxVotedPlayerId: UUID? = nil
        
        for (playerId, votes) in voteCount {
            if votes > maxVotes {
                maxVotes = votes
                maxVotedPlayerId = playerId
            } else if votes == maxVotes {
                // Tie means no one gets executed
                maxVotedPlayerId = nil
            }
        }
        
        // Execute player with most votes
        if let playerId = maxVotedPlayerId {
            if let index = game.players.firstIndex(where: { $0.id == playerId }) {
                game.players[index].isDead = true
                game.lastExecuted = playerId
            }
        }
    }
    
    // MARK: - Observer Pattern
    
    func addObserver(_ observer: GameStateObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: GameStateObserver) {
        observers.removeAll { $0 === observer }
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.gameStateDidChange(game)
        }
    }
    
    // MARK: - Game Reset
    
    func resetGame() {
        game = Game()
        gameState = .start
        currentPhase = .setup
        notifyObservers()
    }
}

// Extended Game enum
enum GamePhase {
    case setup
    case nightTransition // Dusk
    case night
    case dayTransition // Dawn
    case day
    case endGame
}
