//
//  PlayingViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/21/25.
//

import Foundation
class PlayingViewModel : ObservableObject {
    var time : GameLabelState = .day
    var currentTeam : TeamText = .mafia
    var currentRole : RoleText = .mafia
    var instructions : String {
        switch currentTeam {
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
    var roleText : String {
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
