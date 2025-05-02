//
//  DuskView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/2/25.
//


//
//  DuskView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct DuskView: View {
    var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [.red, Color(.displayP3, red: 15/255, green: 5/255, blue: 56/255)]), startPoint: .bottom, endPoint: .top)
			VStack {
				Text("Dusk".uppercased())
					.kerning(10.0)
					.font(.system(.largeTitle, design: .serif, weight: .black))
					.padding()
				Text("Nobody was executed")
					.padding()
				Text("The game continues")
					.padding()
			}
			.background {
				Rectangle()
					.stroke(Color(.systemBackground).opacity(0.13), lineWidth: 20)
					.background(Rectangle().fill(Color(.secondarySystemGroupedBackground).opacity(0.3)))
					.clipped()
			}
        }.ignoresSafeArea()
    }
}

#Preview {
    DuskView()
}
