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
                Text(vm.time.rawValue.uppercased())
                    .kerning(10.0)
                    .font(.system(.largeTitle, design: .serif, weight: .black))
                    .padding()
                Text("You are the \(vm.currentTeam.rawValue.capitalized)")
                Divider()
                Text(vm.instructions.uppercased())
            }
			Spacer()
			// PlayersView
            ScrollView {
                // PlayerGrid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(0..<5) { _ in // Replace with your data model here
                        // PlayerNotes
                        PlayerFullView()
                    }
                }
            }
            Text(vm.rolePowers)
			Divider()
			// Chosen
            HStack {
                // PlayerNotes
                PlayerFullView()
                // Action
                Capsule(style: .continuous)
                    .fill(.red)
                    .frame(width: 70, height: 50)
                    .clipped()
                    .padding()
                    .overlay {
                        Text(vm.roleText)
                            .foregroundStyle(.primary)
                    }
            }
		}
    }
}

#Preview {
    PlayingView()
}

