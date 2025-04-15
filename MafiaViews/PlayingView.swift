//
//  PlayingView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//


//
//  PlayingView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct PlayingView: View {
    var vm : ViewModel = ViewModel()
    var body: some View {
		VStack {
			HeaderView()
			Spacer()
			// PlayersView
            PlayersView()
            Text(vm.rolePowers)
			Divider()
			// Chosen
            SelectionView()
		}
    }
}

#Preview {
    PlayingView()
}

struct SelectionView: View {
    var body: some View {
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
                    Text("Kill")
                        .foregroundStyle(.primary)
                }
        }
    }
}

struct PlayersView: View {
    var body: some View {
        ScrollView {
            // PlayerGrid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(0..<5) { _ in // Replace with your data model here
                    // PlayerNotes
                    PlayerFullView()
                }
            }
        }
    }
}
