//
//  MafiaMenuView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//


//
//  MafiaMenuView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct MafiaMenuView: View {
    var body: some View {
		VStack {
			// Title
			Text("MAFIA")
				.frame()
				.clipped()
				.font(.system(size: 90, weight: .bold, design: .monospaced))
				.padding()
			// Play
			NavigationLink(value: "Hello", label: {
				RoundedRectangle(cornerRadius: 30, style: .continuous)
					.fill(.green)
					.frame(width: 140, height: 70)
					.clipped()
					.overlay {
						Text("Play")
							.foregroundStyle(Color(.systemBackground))
							.font(.title2)
					}
					.shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
			})
			// Credits
			NavigationLink(value: "Hello", label: {
				RoundedRectangle(cornerRadius: 30, style: .continuous)
					.fill(.yellow)
					.frame(width: 140, height: 70)
					.clipped()
					.overlay {
						Text("Credits")
							.foregroundStyle(Color(.systemBackground))
							.font(.title2)
							.frame()
							.clipped()
					}
					.shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
			})
			// Shop
			NavigationLink(value: "Hello", label: {
				RoundedRectangle(cornerRadius: 30, style: .continuous)
					.fill(.red)
					.frame(width: 140, height: 70)
					.clipped()
					.overlay {
						Text("Shop")
							.foregroundStyle(Color(.systemBackground))
							.font(.title2)
							.frame()
							.clipped()
					}
					.shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
			})
		}
    }
}

#Preview {
    MafiaMenuView()
}