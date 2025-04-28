//
//  PlayerFullView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//

import SwiftUI

struct PlayerFullView: View {
    var player : String
    var body: some View {
        // PlayerNotes
        HStack {
            // PlayerView
            PlayerView(player: player)
            .padding()
            // Notes
            Text("Hello, World!")
        }
    }
}

#Preview {
    PlayerFullView(player: "Joe")
}
