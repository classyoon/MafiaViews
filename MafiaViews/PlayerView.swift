//
//  PlayerView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//

import SwiftUI

struct PlayerView: View {
    var body: some View {
        VStack {
            Image("DefaultIcon")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 63)
                .clipped()
                .mask { RoundedRectangle(cornerRadius: 44, style: .continuous) }
                .padding()
            Text("Hi")
        }
    }
}

#Preview {
    PlayerView()
}
