//
//  PauseView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


//
//  PauseView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct PauseView: View {
    var body: some View {
		VStack {
			// Title
			Text("Paused")
				.frame()
				.clipped()
				.font(.system(size: 90, weight: .bold, design: .monospaced))
				.padding()
			Text("It will be John’s turn")
			Divider()
			// Players
			ScrollView {
				VStack {
					ForEach(0..<5) { _ in // Replace with your data model here
						// PlayerView
						HStack {
							Image("myImage")
								.renderingMode(.original)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 63)
								.clipped()
								.mask { RoundedRectangle(cornerRadius: 44, style: .continuous) }
								.padding()
							ZStack {
								RoundedRectangle(cornerRadius: 10, style: .continuous)
									.fill(.green)
									.frame(height: 60)
									.clipped()
								Text("John")
							}
						}
					}
				}
			}
			HStack {
				Text("Resume")
					.padding()
				Text("Restart Game")
					.padding()
			}
		}
    }
}

#Preview {
    PauseView()
}