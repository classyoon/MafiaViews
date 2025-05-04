//
//  PauseView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


import SwiftUI

struct PauseView: View {
    @StateObject private var viewModel = PauseViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToMenu = false
    
    var body: some View {
        VStack {
            // Title
            Text("Paused")
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .padding()
            
            Text("It will be \(viewModel.currentPlayerName)'s turn")
                .font(.title3)
            
            Divider()
            
            // Players list
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.players) { player in
                        HStack {
                            PlayerView(player: player.name)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(player.isDead ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                                    .frame(height: 60)
                                
                                HStack {
                                    Text(player.name)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    Text(player.isDead ? "Dead" : "Alive")
                                        .foregroundColor(player.isDead ? .red : .green)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(player.isDead ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                                        )
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            Spacer()
            
            // Action buttons
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.resume()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Resume")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.restartGame()
                    navigateToMenu = true
                }) {
                    Text("Restart Game")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToMenu) {
            MafiaMenuView()
        }
    }
}
#Preview {
    PauseView()
}
