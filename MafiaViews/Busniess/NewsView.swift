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

#Preview {
    NewsView(viewModel: NewsViewModel())
}
