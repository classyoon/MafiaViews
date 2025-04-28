//
//  PlayingViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/21/25.
//

import Foundation
struct Player : Identifiable {
    var name : String
    var role : RoleText
    var id : UUID = UUID()
    init(_ name: String = "Default Steve", _ role: RoleText = .townsperson) {
        self.name = name
        self.role = role
    }
}
class Game {
    var time : GameLabelState = .day
    var currentTeam : TeamText = .mafia
}
class PlayingViewModel : ObservableObject {
    var time : GameLabelState = .day
    var currentRole : RoleText = .mafia
    var gameModel : Game = Game()
    var players : [Player] = [Player("Joe"),Player("Sam"), Player("Not Killer", .mafia), Player("Yolo"), Player("Funny")]
    var playerInt : Int? = 1
    var player : Player? {
        players[playerInt ?? 0]
    }
    var timeText : String {
        gameModel.time.rawValue
    }
    var roleText : String {
        switch player?.role {
        case .mafia:
            TeamText.mafia.rawValue
        case .detective, .doctor, .townsperson:
            TeamText.townsfolk.rawValue
        case nil:
            "No TEAM"
        }
    }
    var instructions : String {
        switch player?.role {
        case .mafia:
            "Kill off the townsfolk without being caught"
        case .detective, .doctor, .townsperson:
            "Catch the mafia before they kill everyone"
        case nil:
            "No TEAM Text"
        }
    }
    var role : RoleText? {
        player?.role
    }
    var rolePowers : String {
        switch role {
        case .mafia:
            "Whoever you pick, you will kill unless they are saved"
        case .townsperson:
            "You have no powers. Visiting has no affect."
        case .detective:
            "Whoever you pick you learn the role of"
        case .doctor:
            "Whoever you pick you will be protected"
        case nil :
            "No action"
        }
    }
    var actionText : String {
        switch role {
        case .mafia:
            "Kill"
        case .townsperson:
            "Visit"
        case .detective:
            "Investigate"
        case .doctor:
            "Protect"
        case nil :
            "No action text"
        }
    }
}
