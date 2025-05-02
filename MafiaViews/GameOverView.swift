//
//  GameOverView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//


//
//  GameOverView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
		VStack {
			// Title
			Text("Town Wins")
				.clipped()
				.font(.system(size: 90, weight: .bold, design: .monospaced))
				.padding()
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
							Capsule(style: .continuous)
								.fill(.red)
								.frame(width: 70, height: 50)
								.clipped()
								.padding()
								.overlay {
									Text("Town")
										.foregroundStyle(.primary)
								}
						}
					}
				}
			}
			HStack {
				Text("Play Again")
					.padding()
				Text("Menu")
					.padding()
				Text("Play Different")
					.padding()
			}
		}
    }
}

#Preview {
    GameOverView()
}
