//
//  Game.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


import Foundation
class Game {
    var time: GameLabelState = .day
    var currentTeam: TeamText = .mafia
    var players: [Player] = []
    var winner: TeamText? = nil
    var lastExecuted: UUID? = nil
    var investigationResults: [UUID: RoleText] = [:]
    
    // News related properties
    var news: String = ""
    var nightFlavor: String = ""
    var gameText: GameText? = nil
    
    init() {
        loadGameText()
        generateStartNews()
    }
    
    // Load game text from JSON
    private func loadGameText() {
        gameText = loadFlavorText()
    }
    
    // Generate game start news
    func generateStartNews() {
        if let text = gameText?.gameStart.randomElement() {
            news = text
        } else {
            news = "Welcome to Mafia. The game begins."
        }
    }
    
    // Generate night flavor text
    func generateNightFlavor() {
        if let text = gameText?.night.randomElement() {
            nightFlavor = text
        } else {
            nightFlavor = "Night falls on the town."
        }
    }
    
    // Generate news about what happened during the night
    func generateNightNews() {
        let killedPlayers = players.filter { $0.isDead && lastExecuted != $0.id }
        
        if killedPlayers.isEmpty {
            if let text = gameText?.nothingHappen.randomElement() {
                news = text
            } else {
                news = "Nothing happened during the night."
            }
        } else {
            if let murderText = gameText?.murder.randomElement() {
                // Replace placeholder with actual player name if present
                var newsText = murderText
                if murderText.contains("{{Dead}}") {
                    let deadName = killedPlayers.first?.name ?? "Someone"
                    newsText = murderText.replacingOccurrences(of: "{{Dead}}", with: deadName)
                }
                news = newsText
            } else {
                let names = killedPlayers.map { $0.name }.joined(separator: ", ")
                news = "\(names) was killed during the night."
            }
        }
    }
    
    // Generate news about execution
    func generateExecutionNews() {
        if let executedId = lastExecuted,
           let executedPlayer = players.first(where: { $0.id == executedId }) {
            news = "The town has decided to execute \(executedPlayer.name)."
        } else {
            news = "The town couldn't reach a decision. No one was executed."
        }
    }
    
    // Get players for the current player to see based on their role
    func visiblePlayers(for currentPlayer: Player) -> [Player] {
        if currentPlayer.role == .mafia {
            // Mafia can see other mafia
            return players.map { player in
                var modifiedPlayer = player
                if player.role == .mafia {
                    // Make role visible for mafia teammates
                    return modifiedPlayer
                } else {
                    // Hide role for non-mafia
                    return modifiedPlayer
                }
            }
        } else {
            // Town players only see themselves
            return players.map { player in
                var modifiedPlayer = player
                
                // If detective has investigated someone, show their role
                if currentPlayer.role == .detective,
                   let investigatedRole = investigationResults[currentPlayer.id],
                   player.id == currentPlayer.target {
                    modifiedPlayer.role = investigatedRole
                    return modifiedPlayer
                }
                
                return modifiedPlayer
            }
        }
    }
    
    // Helper method to get living players
    func livingPlayers() -> [Player] {
        return players.filter { !$0.isDead }
    }
    
    // Helper method to get living mafia count
    func livingMafiaCount() -> Int {
        return players.filter { !$0.isDead && $0.role == .mafia }.count
    }
    
    // Helper method to get living town count
    func livingTownCount() -> Int {
        return players.filter { !$0.isDead && $0.role != .mafia }.count
    }
}
