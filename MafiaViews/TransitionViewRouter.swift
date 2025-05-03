//
//  TransitionViewRouter.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//

import SwiftUI

struct TransitionViewRouter: View {
    @EnvironmentObject var viewModel: TransitionViewModel
    
    var body: some View {
        Group {
            if viewModel.gameTime == .dusk {
                DuskView()
            } else {
                DawnView()
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    TransitionViewRouter().environmentObject(TransitionViewModel())
}
