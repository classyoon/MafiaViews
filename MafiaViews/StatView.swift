//
//  StatView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//


//
//  StatView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct StatView: View {
    var body: some View {
		VStack {
			// Title
			Text("Stats")
				.frame()
				.clipped()
				.font(.system(size: 90, weight: .bold, design: .monospaced))
				.padding()
			ScrollView {
				VStack {
					ForEach(0..<5) { _ in // Replace with your data model here
						Text("Stat : #")
					}
				}
			}
		}
    }
}

#Preview {
    StatView()
}