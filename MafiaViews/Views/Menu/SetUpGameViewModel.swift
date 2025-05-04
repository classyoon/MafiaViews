//
//  SetUpGameViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


import Foundation
// Setup game view model
class SetUpGameViewModel: ObservableObject, GameStateObserver {
    private let gameManager = GameManager.shared
    
    @Published var players: [Player] = []
    @Published var mafiaCount: Int = 1
    @Published var doctorCount: Int = 0
    @Published var detectiveCount: Int = 0
    @Published var navigateToGame = false
    @Published var navigateToMainMenu = false
    @Published var playerName: String = ""
    @Published var showRoleCounts: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // Computed properties for validation
    var maxMafia: Int {
        max(1, players.count / 3) // Maximum 1/3 of players can be mafia
    }
    
    var maxSpecialRoles: Int {
        max(1, players.count - 2) // At least 2 townspeople
    }
    
    var canIncrementMafia: Bool {
        mafiaCount < maxMafia && mafiaCount + doctorCount + detectiveCount < maxSpecialRoles
    }
    
    var canIncrementDoctor: Bool {
        doctorCount < 2 && mafiaCount + doctorCount + detectiveCount < maxSpecialRoles
    }
    
    var canIncrementDetective: Bool {
        detectiveCount < 2 && mafiaCount + doctorCount + detectiveCount < maxSpecialRoles
    }
    
    var minPlayers: Int {
        return 4 // Minimum needed for a basic game
    }
    
    var hasMinimumPlayers: Bool {
        return players.count >= minPlayers
    }
    
    init() {
        gameManager.addObserver(self)
        self.players = gameManager.game.players
        
        // Auto-populate with minimum players if empty
        if players.isEmpty {
            populateWithDefaultPlayers(count: minPlayers)
        }
    }
    
    deinit {
        gameManager.removeObserver(self)
    }
    
    func gameStateDidChange(_ game: Game) {
        // Ensure UI updates happen on the main thread
        DispatchQueue.main.async {
            self.players = game.players
        }
    }
    
    func addPlayer() {
        guard !playerName.isEmpty else { return }
        _ = gameManager.addPlayer(name: playerName)
        playerName = ""
    }
    
    func addQuickPlayer() {
        let newName = "Player \(players.count + 1)"
        _ = gameManager.addPlayer(name: newName)
    }
    
    func populateWithDefaultPlayers(count: Int) {
        gameManager.populateWithDefaultPlayers(count: count)
        defaultRoles() // Set default roles for the new players
    }
    
    func removePlayer(_ player: Player) {
        gameManager.removePlayer(player)
        
        // Adjust role counts if they exceed the new player count
        if mafiaCount > maxMafia {
            mafiaCount = maxMafia
        }
        
        if mafiaCount + doctorCount + detectiveCount > maxSpecialRoles {
            // Prioritize keeping mafia, then reduce doctors/detectives
            if doctorCount > 0 {
                doctorCount -= 1
            } else if detectiveCount > 0 {
                detectiveCount -= 1
            }
        }
    }
    
    func defaultRoles() {
        gameManager.setDefaultRoles()
        updateRoleCounts()
    }
    
    func randomRoles() {
        gameManager.setRandomRoles()
        updateRoleCounts()
    }
    
    func mysteryRoles() {
        // Use random roles but don't reveal the counts
        gameManager.setRandomRoles()
        showRoleCounts = false
    }
    
    func startGame() {
        if !hasMinimumPlayers {
            errorMessage = "Need at least \(minPlayers) players to start"
            showError = true
            return
        }
        
        if showRoleCounts {
            gameManager.assignRoles(mafia: mafiaCount, doctors: doctorCount, detectives: detectiveCount)
        }
        // If not showing role counts, we already assigned them with mystery/random roles
        
        gameManager.startGame()
        navigateToGame = true
    }
    
    func incrementMafia() {
        if canIncrementMafia {
            mafiaCount += 1
        } else {
            errorMessage = "Maximum mafia count reached (1/3 of players)"
            showError = true
        }
    }
    
    func decrementMafia() {
        if mafiaCount > 1 {
            mafiaCount -= 1
        } else {
            errorMessage = "At least one mafia member is required"
            showError = true
        }
    }
    
    func incrementDoctor() {
        if canIncrementDoctor {
            doctorCount += 1
        } else {
            errorMessage = "Cannot add more special roles"
            showError = true
        }
    }
    
    func decrementDoctor() {
        if doctorCount > 0 {
            doctorCount -= 1
        }
    }
    
    func incrementDetective() {
        if canIncrementDetective {
            detectiveCount += 1
        } else {
            errorMessage = "Cannot add more special roles"
            showError = true
        }
    }
    
    func decrementDetective() {
        if detectiveCount > 0 {
            detectiveCount -= 1
        }
    }
    
    func updateRoleCounts() {
        mafiaCount = players.filter { $0.role == .mafia }.count
        doctorCount = players.filter { $0.role == .doctor }.count
        detectiveCount = players.filter { $0.role == .detective }.count
        showRoleCounts = true
    }
}