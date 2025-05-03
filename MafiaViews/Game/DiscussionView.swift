//
//  DiscussionView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


//
//  DiscussionView.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct DiscussionView: View {
    var body: some View {
		VStack {
			Text("Day".uppercased())
				.kerning(10.0)
				.font(.system(.largeTitle, design: .serif, weight: .black))
				.padding()
			Text("Breaking News ")
			Divider()
			Text("Time to Discuss : 100 seconds".uppercased())
			Spacer()
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
			Spacer()
			HStack {
				Spacer()
				Text("Next")
					.padding(30)
			}
		}
    }
}

#Preview {
    DiscussionView()
}