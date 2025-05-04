//
//  DiscussionView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//

import SwiftUI
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
#Preview {
    DiscussionView(viewModel: DiscussionViewModel())
}
