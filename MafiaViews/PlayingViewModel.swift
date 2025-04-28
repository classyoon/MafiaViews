//
//  PlayingViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/21/25.
//

import Foundation
class Player {
    var name : String
    var role : RoleText
    init(_ name: String = "Default Steve", _ role: RoleText = .townsfolk) {
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
    var playerInt : Int? = nil
    var player : Player? {
        players[playerInt ?? 0]
    }
    var timeText : String {
        gameModel.time.rawValue
    }
    var roleText : String {
        gameModel.currentTeam.rawValue
    }
    var instructions : String {
        switch gameModel.currentTeam {
        case .mafia:
            "Try to kill off the townsfolk without being caught"
        case .townsfolk:
            "Try to catch the mafia before they kill everyone"
        }
    }
    var rolePowers : String {
        switch currentRole {
        case .mafia:
            "Whoever you pick dies"
        case .townsfolk:
            "You have no powers"
        case .detective:
            "Whoever you pick you learn the role of"
        case .doctor:
            "Whoever you pick you will be protected"
        }
    }
    var actionText : String {
        switch currentRole {
        case .mafia:
            "Kill"
        case .townsfolk:
            "Sleep"
        case .detective:
            "Investigate"
        case .doctor:
            "Protect"
        }
    }
}
