//
//  PlayerFullView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//

import SwiftUI

struct PlayerFullView: View {
    var body: some View {
        // PlayerNotes
        HStack {
            // PlayerView
            PlayerView()
            .padding()
            // Notes
            Text("Hello, World!")
        }
    }
}

#Preview {
    PlayerFullView()
}
