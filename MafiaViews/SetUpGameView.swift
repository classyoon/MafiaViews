//
//  SetUpGameView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//

import SwiftUI

struct SetUpGameView: View {
    @StateObject private var viewModel = SetUpGameViewModel()
    @State private var showNameInput = false
    
    var body: some View {
        VStack {
            Text("create game".uppercased())
                .kerning(10.0)
                .font(.system(.largeTitle, design: .serif, weight: .black))
                .padding()
            
            Divider()
            
            Text("Players: \(viewModel.players.count)")
                .font(.title2)
                .padding(.bottom, 5)
            
            // Add player button
            Button(action: {
                showNameInput = true
            }) {
                Label("Add Player", systemImage: "person.badge.plus")
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showNameInput) {
                VStack {
                    Text("Add Player")
                        .font(.headline)
                        .padding()
                    
                    TextField("Player Name", text: $viewModel.playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Cancel") {
                            showNameInput = false
                            viewModel.playerName = ""
                        }
                        .padding()
                        
                        Button("Add") {
                            viewModel.addPlayer()
                            showNameInput = false
                        }
                        .padding()
                        .disabled(viewModel.playerName.isEmpty)
                    }
                }
                .padding()
            }
            
            // Settings
            VStack(spacing: 15) {
                // Confirm Buttons
                HStack {
                    Spacer()
                    Button(action: viewModel.defaultRoles) {
                        Text("Default")
                            .padding()
                            .background(Color.green.opacity(0.3))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    Button(action: viewModel.randomRoles) {
                        Text("Random")
                            .padding()
                            .background(Color.orange.opacity(0.3))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                
                // Role counts
                Group {
                    // Mafia
                    HStack {
                        Text("Mafia")
                            .frame(width: 80, alignment: .leading)
                        
                        Stepper("\(viewModel.mafiaCount)",
                                onIncrement: viewModel.incrementMafia,
                                onDecrement: viewModel.decrementMafia)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Doctor
                    HStack {
                        Text("Doctor")
                            .frame(width: 80, alignment: .leading)
                        
                        Stepper("\(viewModel.doctorCount)",
                                onIncrement: viewModel.incrementDoctor,
                                onDecrement: viewModel.decrementDoctor)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Detective
                    HStack {
                        Text("Detective")
                            .frame(width: 80, alignment: .leading)
                        
                        Stepper("\(viewModel.detectiveCount)",
                                onIncrement: viewModel.incrementDetective,
                                onDecrement: viewModel.decrementDetective)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
            
            // PlayersView
            ScrollView {
                // PlayerGrid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(viewModel.players) { player in
                        VStack {
                            ZStack(alignment: .topTrailing) {
                                PlayerView(player: player.name)
                                
                                Button(action: {
                                    withAnimation {
                                        viewModel.removePlayer(player)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Circle().fill(Color.white))
                                }
                                .offset(x: 5, y: -5)
                            }
                        }
                    }
                }
            }
            .id(viewModel.players.count) // Force refresh when player count changes
            .padding()
            
            // Begin button
            HStack {
                Spacer()
                
                NavigationLink(destination:
                    DuskView().environmentObject(TransitionViewModel())
                ) {
                    Text("Begin")
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .simultaneousGesture(TapGesture().onEnded { _ in
                    viewModel.startGame()
                })
                .disabled(viewModel.players.count < 4)
                .opacity(viewModel.players.count < 4 ? 0.5 : 1.0)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("") // Remove extra title
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SetUpGameView()
}
