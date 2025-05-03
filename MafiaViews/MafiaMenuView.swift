//
//  MafiaMenuView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//

import SwiftUI

struct MafiaMenuView: View {
    @StateObject private var viewModel = MafiaMenuViewModel()
    
    var body: some View {
        VStack {
            // Title
            Text("MAFIA")
                .frame()
                .clipped()
                .font(.system(size: 90, weight: .bold, design: .monospaced))
                .padding()
            
            // Play
            NavigationLink(destination: SetUpGameView()) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.green)
                    .frame(width: 140, height: 70)
                    .clipped()
                    .overlay {
                        Text("Play")
                            .foregroundStyle(Color(.systemBackground))
                            .font(.title2)
                    }
                    .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
            }
            .padding()
            
            // Credits
            NavigationLink(destination: StatView()) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.yellow)
                    .frame(width: 140, height: 70)
                    .clipped()
                    .overlay {
                        Text("Stats")
                            .foregroundStyle(Color(.systemBackground))
                            .font(.title2)
                            .frame()
                            .clipped()
                    }
                    .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
            }
            .padding()
            
            // Shop
            NavigationLink(destination: StoreView()) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.red)
                    .frame(width: 140, height: 70)
                    .clipped()
                    .overlay {
                        Text("Shop")
                            .foregroundStyle(Color(.systemBackground))
                            .font(.title2)
                            .frame()
                            .clipped()
                    }
                    .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
            }
            .padding()
        }
    }
}

#Preview {
    MafiaMenuView()
}
