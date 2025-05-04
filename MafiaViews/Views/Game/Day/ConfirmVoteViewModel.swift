//
//  ConfirmVoteViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


import Foundation
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