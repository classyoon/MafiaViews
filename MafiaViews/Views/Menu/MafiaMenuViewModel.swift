//
//  ViewModels.swift
//  MafiaViews
//
//  Created on 5/2/25.
//

import Foundation
import SwiftUI
import Combine

// Main menu view model
class MafiaMenuViewModel: ObservableObject {
    @Published var navigateToSetup = false
    @Published var navigateToCredits = false
    @Published var navigateToStore = false
    
    func startGame() {
        navigateToSetup = true
    }
    
    func showCredits() {
        navigateToCredits = true
    }
    
    func showStore() {
        navigateToStore = true
    }
}





// Update GameManager.swift to add isFirstNight functionality
// Add this property and method to the GameManager class

extension GameManager {
    var isFirstNight: Bool {
        // Consider it the first night if we're in the first night transition and no players are dead
        return currentPhase == .nightTransition && !game.players.contains(where: { $0.isDead })
    }
}


