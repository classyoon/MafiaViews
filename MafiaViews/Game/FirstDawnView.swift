//
//  FirstDawnView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


//
//  FirstDawnView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct FirstDawnView: View {
    var body: some View {
		VStack {
			Text("Dawn".uppercased())
				.kerning(10.0)
				.font(.system(.largeTitle, design: .serif, weight: .black))
			Text("The Game Begins")
		}
    }
}

#Preview {
    FirstDawnView()
}