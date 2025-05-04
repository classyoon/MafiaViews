//
//  ConfirmNightView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


//
//  ConfirmNightView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct ConfirmNightView: View {
    var body: some View {
		// ConfirmNightView
		VStack {
			Spacer()
			Circle()
			Spacer()
			VStack {
				Text("Night".uppercased())
					.kerning(10.0)
					.font(.system(.largeTitle, design: .serif, weight: .black))
					.frame(maxWidth: .infinity)
					.clipped()
				Text("Has everyone taken their turn?")
					.padding()
				// Confirm Buttons
				HStack {
					Spacer()
					Text("Yes")
					Spacer()
					Text("Restart")
					Spacer()
				}
			}
			Spacer()
		}
    }
}

#Preview {
    ConfirmNightView()
}