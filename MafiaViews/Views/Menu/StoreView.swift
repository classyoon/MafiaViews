//
//  StoreView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//


//
//  StoreView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct StoreView: View {
    var body: some View {
		VStack {
			// Title
			Text("Store")
				.clipped()
				.font(.system(size: 90, weight: .bold, design: .monospaced))
				.padding()
			// Items
			ScrollView {
				VStack {
					ForEach(0..<5) { _ in // Replace with your data model here
						// ItemView
						HStack {
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
									Text("Buy")
										.foregroundStyle(.primary)
								}
						}
					}
				}
			}
		}
    }
}

#Preview {
    StoreView()
}
