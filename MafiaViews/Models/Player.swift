//
//  Player.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
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