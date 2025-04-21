//
//  SubViews.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/21/25.
//

import SwiftUI
struct HeaderView: View {
    var vm : PlayingViewModel = PlayingViewModel()
    var body: some View {
        VStack{
            Text(vm.time.rawValue.uppercased())
                .kerning(10.0)
                .font(.system(.largeTitle, design: .serif, weight: .black))
                .padding()
            Text("You are the \(vm.currentTeam.rawValue.capitalized)")
            Divider()
            Text(vm.instructions.uppercased())
        }
    }
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

struct SubViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SubViews()
}
