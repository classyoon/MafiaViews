//
//  PlayingView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//


import SwiftUI
struct PlayingView: View {
    var vm : PlayingViewModel = PlayingViewModel()
    private var chosen : Int = 0
    var body: some View {
		VStack {
            VStack{
                Text(vm.timeText.uppercased())
                    .kerning(10.0)
                    .font(.system(.largeTitle, design: .serif, weight: .black))
                    .padding()
                Text("You are the \(vm.roleText.capitalized)")
                Divider()
                Text(vm.instructions.uppercased())
            }
			Spacer()
			// PlayersView
            ScrollView {
                // PlayerGrid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(0..<4) { chosen in // Replace with your data model here
                        // PlayerNotes
                        PlayerFullView(player: vm.players[chosen])
                    }
                }
            }
            Text(vm.rolePowers)
			Divider()
			// Chosen
            HStack {
                // PlayerNotes
                PlayerFullView(player: vm.players[chosen])
                // Action
                Capsule(style: .continuous)
                    .fill(.red)
                    .frame(width: 70, height: 50)
                    .clipped()
                    .padding()
                    .overlay {
                        Text(vm.actionText)
                            .foregroundStyle(.primary)
                    }
            }
		}
    }
}

#Preview {
    PlayingView()
}

