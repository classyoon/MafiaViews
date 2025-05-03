//
//  ConfirmVoteView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//

import SwiftUI

struct ConfirmVoteView: View {
    @ObservedObject var viewModel: ConfirmVoteViewModel
    var isVoting: Bool
    
    init(viewModel: ConfirmVoteViewModel, isVoting: Bool = true) {
        self.viewModel = viewModel
        self.isVoting = isVoting
    }
    
    var body: some View {
        VStack {
            Text(isVoting ? "Execution".uppercased() : "Confirm".uppercased())
                .kerning(10.0)
                .font(.system(.largeTitle, design: .serif, weight: .black))
            
            Text(isVoting ?
                 "Shall \(viewModel.playerName) be executed?" :
                 "Use your \(viewModel.action) action on \(viewModel.playerName)?")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            
            // Confirm Buttons
            HStack(spacing: 50) {
                Button(action: viewModel.confirm) {
                    Text("Yes")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 100)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: viewModel.cancel) {
                    Text("Cancel")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 100)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.top, 20)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
        .foregroundStyle(.primary)
    }
}

#Preview {
    ConfirmVoteView(
        viewModel: ConfirmVoteViewModel(
            playerName: "John",
            action: "Kill",
            onConfirm: {},
            onCancel: {}
        )
    )
}
