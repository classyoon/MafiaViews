//
//  NewsView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


// Add this to MafiaViews/Game/NewsView.swift

import SwiftUI

struct NewsView: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var showNextScreen = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: viewModel.backgroundColor), 
                startPoint: .bottom, 
                endPoint: .top
            )
            
            VStack {
                Text("NEWS".uppercased())
                    .kerning(10.0)
                    .font(.system(.largeTitle, design: .serif, weight: .black))
                    .foregroundColor(.white)
                    .padding()
                
                Text(viewModel.newsHeadline)
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text(viewModel.newsContent)
                    .foregroundColor(.white)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if let deadPlayer = viewModel.deadPlayer {
                    VStack {
                        PlayerView(player: deadPlayer.name)
                        
                        Text(deadPlayer.role.rawValue.capitalized)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                Capsule()
                                    .fill(deadPlayer.team == .mafia ? Color.red.opacity(0.7) : Color.blue.opacity(0.7))
                            )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.3))
                    )
                    .padding()
                }
                
                Spacer()
                
                Text("Tap to continue")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
                    .opacity(0.8)
            }
            .background {
                Rectangle()
                    .stroke(Color(.systemBackground).opacity(0.13), lineWidth: 20)
                    .background(Rectangle().fill(Color(.secondarySystemGroupedBackground).opacity(0.3)))
                    .clipped()
            }
            .onTapGesture {
                viewModel.continueToNextPhase()
                showNextScreen = true
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showNextScreen) {
            DiscussionView(viewModel: DiscussionViewModel())
        }
    }
}

// Add this to MafiaViews/Game/NewsViewModel.swift

import Foundation
import SwiftUI

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

// Add this to MafiaViews/Game/DiscussionView.swift 
// (replacing the existing file content)

import SwiftUI

class DiscussionViewModel: ObservableObject {
    private let gameManager = GameManager.shared
    
    @Published var timeRemaining: Int = 60
    @Published var canSkipDiscussion = false
    @Published var continueToVoting = false
    
    private var timer: Timer?
    
    init(discussionTime: Int = 60) {
        self.timeRemaining = discussionTime
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                // Allow skipping after half the time has passed
                if self.timeRemaining <= 30 {
                    self.canSkipDiscussion = true
                }
            } else {
                self.timer?.invalidate()
                self.continueToVoting = true
            }
        }
    }
    
    func skipDiscussion() {
        if canSkipDiscussion {
            timer?.invalidate()
            continueToVoting = true
        }
    }
}

struct DiscussionView: View {
    @ObservedObject var viewModel: DiscussionViewModel
    @State private var continueToVoting = false
    
    var body: some View {
        VStack {
            // Header
            Text("Day".uppercased())
                .kerning(10.0)
                .font(.system(.largeTitle, design: .serif, weight: .black))
                .padding()
            
            Text("Time to Discuss")
                .font(.title2)
            
            // Timer
            ZStack {
                Circle()
                    .stroke(lineWidth: 5)
                    .opacity(0.3)
                    .foregroundColor(Color.red)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(viewModel.timeRemaining) / 60.0)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: 270.0))
                
                Text("\(viewModel.timeRemaining)")
                    .font(.title)
                    .bold()
            }
            .frame(width: 120, height: 120)
            .padding()
            
            Text("Discuss who might be the Mafia")
                .font(.headline)
                .padding()
            
            Text("Everyone should participate!")
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            Spacer()
            
            // Skip button (only visible after half time)
            if viewModel.canSkipDiscussion {
                Button(action: {
                    viewModel.skipDiscussion()
                }) {
                    Text("Skip to Voting")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Present the pause view as a sheet
                    // Implementation would be in the parent navigation controller
                }) {
                    Image(systemName: "pause.circle.fill")
                        .font(.title)
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.continueToVoting) {
            PlayingView()
        }
    }
}