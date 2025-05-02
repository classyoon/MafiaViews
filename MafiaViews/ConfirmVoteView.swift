//
//  ConfirmVoteView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//


//
//  ConfirmVoteView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct ConfirmVoteView: View {
    var body: some View {
		VStack {
			Text("Execution".uppercased())
				.kerning(10.0)
				.font(.system(.largeTitle, design: .serif, weight: .black))
			Text("Shall John be executed?")
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
		.foregroundStyle(.primary)
    }
}

#Preview {
    ConfirmVoteView()
}
