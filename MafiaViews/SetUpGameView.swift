//
//  SetUpGameView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//


//
//  SetUpGameView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct SetUpGameView: View {
    var body: some View {
		VStack {
         
			Text("create game".uppercased())
				.kerning(10.0)
				.font(.system(.largeTitle, design: .serif, weight: .black))
				.padding()
			Divider()
			Text("Players : 5")
			// Settings
			VStack {
				// Confirm Buttons
                HStack {
                    Spacer()
                    Button {
                        print("Setting default distribution of roles")
                    } label: {
                        Text("Default")
                    }
                    
                    Spacer()
                    Button {
                        print("Setting random (within reason) distribution of roles")
                    } label: {
                        Text("Guess")
                    }
					
					Spacer()
				}
				// Doctors
				Rectangle()
					.fill(.mint)
					.overlay {
						Text("Doctor #")
					}
				// Detective
				Rectangle()
					.fill(.mint)
					.overlay {
						Text("Detective #")
					}
				// Mafia
				Rectangle()
					.fill(.mint)
					.overlay {
						Text("Mafia #")
					}
			}
			.frame(height: 120)
			.clipped()
			// PlayersView
			ScrollView {
				// PlayerGrid
				LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
					ForEach(0..<5) { _ in // Replace with your data model here
						// PlayerView
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
			}
			// Go Area
			HStack {
				Spacer()
				// Begin
                NavigationLink {
                    DuskView()
                } label: {
                    Text("Begin")
                        .padding(30)
                }

			}
		}
    }
}

#Preview {
    SetUpGameView()
}
