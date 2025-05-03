//
//  GameOverView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//

import SwiftUI

struct GameOverView: View {
    @StateObject private var viewModel = GameOverViewModel()
    @State private var navigateToMainMenu = false
    @State private var navigateToNewGame = false
    
    var body: some View {
        VStack {
            // Title
            Text("\(viewModel.winner?.rawValue.capitalized ?? "No one") Wins!")
                .clipped()
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .padding()
                .foregroundColor(viewModel.winner == .mafia ? .red : .green)
            
            // Players
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.players) { player in
                        // PlayerView
                        HStack {
                            PlayerView(player: player.name)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(player.isDead ? .red.opacity(0.2) : .green.opacity(0.2))
                                    .frame(height: 60)
                                    .clipped()
                                
                                Text(player.isDead ? "Dead" : "Alive")
                                    .foregroundColor(player.isDead ? .red : .green)
                                    .font(.headline)
                            }
                            
                            Capsule(style: .continuous)
                                .fill(player.team == .mafia ? .red : .blue)
                                .frame(width: 90, height: 50)
                                .clipped()
                                .padding()
                                .overlay {
                                    Text(player.role.rawValue.capitalized)
                                        .foregroundStyle(.white)
                                        .font(.callout)
                                }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding()
            
            // Action buttons
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.playAgain()
                    navigateToNewGame = true
                }) {
                    Text("Play Again")
                        .padding()
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.goToMenu()
                    navigateToMainMenu = true
                }) {
                    Text("Menu")
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.playDifferent()
                    navigateToNewGame = true
                }) {
                    Text("New Game")
                        .padding()
                        .background(Color.orange.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.vertical, 30)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToMainMenu) {
            MafiaMenuView()
        }
        .navigationDestination(isPresented: $navigateToNewGame) {
            SetUpGameView()
        }
    }
}

#Preview {
    GameOverView()
}
