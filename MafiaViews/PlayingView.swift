//
//  PlayingView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//


import SwiftUI
struct PlayingView: View {
    var vm : PlayingViewModel = PlayingViewModel()
    var body: some View {
		VStack {
            VStack{
                Text(vm.timeText.uppercased())
                    .kerning(10.0)
                    .font(.system(.largeTitle, design: .serif, weight: .black))
                    .padding()
                Text("Hi \( vm.player!.name). You are a \(vm.roleText.capitalized)")
                Divider()
                Text(vm.instructions.uppercased())
            }
			Spacer()
			// PlayersView
            ScrollView {
                // PlayerGrid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(vm.players)  { cplayer in
                        PlayerFullView(player: cplayer)
                    }
                }
            }
            Text(vm.rolePowers)
			Divider()
			// Chosen
            HStack {
                // PlayerNotes
                PlayerFullView(player: vm.player ?? Player())
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

