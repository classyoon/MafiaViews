//
//  GameStates.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//

import Foundation

enum GameLabelState : String {
    case day, dawn, dusk, night
}
enum RoleText : String {
    case mafia
    case detective
    case doctor
    case townsperson
}
enum TeamText : String {
    case mafia
    case townsfolk
}
enum PlayerStage {
    case start, playing, ended
}
