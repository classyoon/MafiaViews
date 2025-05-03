//
//  Player.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


//
//  GameModels.swift
//  MafiaViews
//
//  Created on 5/2/25.
//

import Foundation

struct Player: Identifiable {
    var name: String
    var role: RoleText
    var id: UUID = UUID()
    var isDead: Bool = false
    var notes: String = ""
    var hasActed: Bool = false
    var target: UUID? = nil
    
    init(_ name: String = "Default Steve", _ role: RoleText = .townsperson) {
        self.name = name
        self.role = role
    }
    
    // Get team based on role
    var team: TeamText {
        switch role {
        case .mafia:
            return .mafia
        case .detective, .doctor, .townsperson:
            return .townsfolk
        }
    }
}

class Game {
    var time: GameLabelState = .day
    var currentTeam: TeamText = .mafia
    var players: [Player] = []
    var winner: TeamText? = nil
    var lastExecuted: UUID? = nil
    var investigationResults: [UUID: RoleText] = [:] // Mapping detective ID to target's role
    
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