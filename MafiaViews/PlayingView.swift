//
//  PlayingView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//


import SwiftUI
struct PlayingView: View {
    var vm : PlayingViewModel = PlayingViewModel(time: .day)
        
    @State private var player : Player?
    var headerText : String {
        var starter = "Hi \( vm.player!.name), you are a \(vm.player!.role.rawValue.capitalized)!"
        if vm.time == .night {
            starter += " It is night time."
        }else {
            starter += " It is day time."
        }
        return starter
    }
    var instructorText : String {
        if vm.time == .day {
            return "Try convince others to vote in a way that furthers your teams intrests."
        }
        return vm.instructions.uppercased()
    }
    var body: some View {
        VStack {
            VStack{
                Text(vm.timeText.uppercased())
                    .lineLimit(nil)
                    .kerning(10.0)
                    .font(.system(.largeTitle, design: .serif, weight: .black))
                Text(headerText)
                
                
                    
                Divider()
                    Text(instructorText)
            }
            Spacer()
            // PlayersView
            ScrollView {
                // PlayerGrid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(vm.showPlayers)  { cplayer in
                        PlayerFullView(player: cplayer)
                    }
                }
            }
            Text(vm.rolePowers)
            Divider()
            // Chosen
            HStack {
                // PlayerNotes
                if let p = player {
                    PlayerView(player: p.name)
                    // Action
                    Button {
                        print("Button pressed")
                    } label: {
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
                else {
                    Text("Tap on a player icon to select them.").padding()
                   Spacer()
                }
                Button {
                    print("Button pressed")
                } label: {
                    Capsule(style: .continuous)
                        .fill(.yellow)
                        .frame(width: 70, height: 50)
                        .clipped()
                        .padding()
                        .overlay {
                            Text("Skip")
                                .foregroundStyle(.primary)
                        }
                    
                }
                
            }
        }
    }
}

#Preview {
    PlayingView()
}

