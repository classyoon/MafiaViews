//
//  PlayingViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/21/25.
//

import Foundation
class PlayingViewModel : ObservableObject {
    
    var gameModel : Game = Game()
    var playerInt : Int? = 1
    var player : Player? {
        gameModel.players[playerInt ?? 0]
    }
    var showPlayers: [Player] {
        gameModel.players.filter { $0.id != player?.id ?? UUID() }
    }
    var time : GameLabelState {
        gameModel.time
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
        if gameModel.time == .day {
            "Pick someone to vote to eliminate or abstain."
        }
        else {
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
    }
    var actionText : String {
        if gameModel.time == .day {
            "Vote"
        }else {
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
    init(time: GameLabelState = .night,  gameModel: Game = Game(), playerInt: Int? = nil) {
        self.gameModel = gameModel
        self.playerInt = playerInt
        gameModel.time = time
       
    }
}
