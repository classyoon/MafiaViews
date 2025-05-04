//
//  NewsViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//

import SwiftUI
import Foundation
class NewsViewModel: ObservableObject, GameStateObserver {
    private let gameManager = GameManager.shared
    
    @Published var newsHeadline: String = ""
    @Published var newsContent: String = ""
    @Published var backgroundColor: [Color] = [.blue, .purple]
    @Published var deadPlayer: Player? = nil
    
    init() {
        gameManager.addObserver(self)
        updateNewsFromGameState()
    }
    
    deinit {
        gameManager.removeObserver(self)
    }
    
    func gameStateDidChange(_ game: Game) {
        updateNewsFromGameState()
    }
    
    private func updateNewsFromGameState() {
        let game = gameManager.game
        
        // Set news content from game
        newsContent = game.news
        
        // Find any dead player from last night (not executed)
        if gameManager.currentPhase == .dayTransition {
            // Show news about night events
            newsHeadline = "Last Night..."
            backgroundColor = [.black, .indigo]
            
            // Find newly dead player
            let deadPlayers = game.players.filter { 
                $0.isDead && game.lastExecuted != $0.id 
            }
            
            if !deadPlayers.isEmpty {
                deadPlayer = deadPlayers.first
            } else {
                deadPlayer = nil
            }
        } else if gameManager.currentPhase == .nightTransition {
            // Show news about day events/execution
            newsHeadline = "Town Meeting Results"
            backgroundColor = [.orange, .red]
            
            // Show executed player if any
            if let executedId = game.lastExecuted,
               let executed = game.players.first(where: { $0.id == executedId }) {
                deadPlayer = executed
            } else {
                deadPlayer = nil
            }
        } else {
            // Default news (game start)
            newsHeadline = "Breaking News"
            backgroundColor = [.blue, .purple]
            deadPlayer = nil
        }
    }
    
    func continueToNextPhase() {
        // Mark that we've shown the news
        gameManager.advancePhase()
    }
}

