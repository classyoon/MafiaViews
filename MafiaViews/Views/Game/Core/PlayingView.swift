//
//  PlayingView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//  Updated with enhanced functionality
//

// Update MafiaViews/Game/PlayingView.swift to include pause functionality

import SwiftUI

struct PlayingView: View {
    @StateObject private var viewModel = EnhancedPlayingViewModel()
    
    @State private var playerNotes: String = ""
    @State private var showConfirmationDialog = false
    @State private var showPauseView = false
    
    var headerText: String {
        guard let player = viewModel.currentPlayer else {
            return "Loading..."
        }
        
        var starter = "Hi \(player.name), you are a \(player.role.rawValue.capitalized)!"
        if viewModel.time == .night {
            starter += " It is night time."
        } else {
            starter += " It is day time."
        }
        return starter
    }
    
    var instructorText: String {
        if viewModel.time == .day {
            return "Try to convince others to vote in a way that furthers your team's interests."
        }
        return viewModel.instructions.uppercased()
    }
    
    var body: some View {
        VStack {
            // Header section
            VStack {
                Text(viewModel.timeText.uppercased())
                    .lineLimit(nil)
                    .kerning(10.0)
                    .font(.system(.largeTitle, design: .serif, weight: .black))
                
                Text(headerText)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 5)
                
                Divider()
                
                Text(instructorText)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
            }
            .padding(.horizontal)
            
            // Player list section
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(viewModel.otherPlayers) { player in
                        Button {
                            viewModel.selectPlayer(player)
                            showConfirmationDialog = true
                        } label: {
                            PlayerFullView(player: player)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.vertical, 5)
            
            // Instructions
            Text(viewModel.rolePowers)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Divider()
            
            // Action section
            HStack {
                if let selectedPlayer = viewModel.selectedPlayer {
                    PlayerView(player: selectedPlayer.name)
                    
                    // Action button
                    Button {
                        showConfirmationDialog = true
                    } label: {
                        Capsule(style: .continuous)
                            .fill(.red)
                            .frame(width: 70, height: 50)
                            .clipped()
                            .padding()
                            .overlay {
                                Text(viewModel.actionText)
                                    .foregroundStyle(.white)
                            }
                    }
                } else {
                    Text("Tap on a player to select them.")
                        .padding()
                    Spacer()
                }
                
                // Skip button
                Button {
                    viewModel.skipAction()
                } label: {
                    Capsule(style: .continuous)
                        .fill(.yellow)
                        .frame(width: 70, height: 50)
                        .clipped()
                        .padding()
                        .overlay {
                            Text("Skip")
                                .foregroundStyle(.primary)
                        }
                }
            }
            .padding(.horizontal)
            
            // Notes section for the current player
            if let currentPlayer = viewModel.currentPlayer {
                VStack(alignment: .leading) {
                    Text("Your Notes (private until you die)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("Notes", text: $playerNotes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3)
                        .onChange(of: playerNotes) { viewModel.updateNotes(text: playerNotes) }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .onAppear {
                    playerNotes = currentPlayer.notes
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.pauseGame()
                    showPauseView = true
                }) {
                    Image(systemName: "pause.circle.fill")
                        .font(.title)
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.showTransition) {
            if viewModel.time == .dawn {
                NewsView(viewModel: NewsViewModel())
            } else {
                DuskView()
                    .environmentObject(TransitionViewModel())
            }
        }
        .navigationDestination(isPresented: $viewModel.gameEnded) {
            GameOverView()
        }
        .sheet(isPresented: $showPauseView) {
            PauseView()
        }
        .overlay {
            if showConfirmationDialog, let player = viewModel.selectedPlayer {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ConfirmVoteView(
                        viewModel: ConfirmVoteViewModel(
                            playerName: player.name,
                            action: viewModel.actionText,
                            onConfirm: {
                                viewModel.confirmAction()
                                showConfirmationDialog = false
                            },
                            onCancel: {
                                showConfirmationDialog = false
                            }
                        ),
                        isVoting: viewModel.time == .day
                    )
                    .padding()
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showConfirmationDialog)
    }
}

// Update EnhancedPlayingViewModel to include pause functionality

extension EnhancedPlayingViewModel {
    func pauseGame() {
        gameManager.pauseGame()
        // Save current player ID
        if let player = currentPlayer {
            gameManager.setCurrentPlayer(player.id)
        }
    }
}
