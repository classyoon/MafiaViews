//
//  HeaderView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 4/15/25.
//

import SwiftUI

class ViewModel : ObservableObject {
    var time : GameLabelState = .day
    var currentTeam : TeamText = .mafia
    var currentRole : RoleText = .mafia
    var instructions : String {
        switch currentTeam {
        case .mafia:
            "Try to kill off the townsfolk without being caught"
        case .townsfolk:
            "Try to catch the mafia before they kill everyone"
        }
    }
    var rolePowers : String {
        switch currentRole {
        case .mafia:
            "Whoever you pick dies"
        case .townsfolk:
            "You have no powers"
        case .detective:
            "Whoever you pick you learn the role of"
        case .doctor:
            "Whoever you pick you will be protected"
        }
    }
}



struct HeaderView: View {
    var vm : ViewModel = ViewModel()
    var body: some View {
        VStack{
            Text(vm.time.rawValue.uppercased())
                .kerning(10.0)
                .font(.system(.largeTitle, design: .serif, weight: .black))
                .padding()
            Text("You are the \(vm.currentTeam.rawValue.capitalized)")
            Divider()
            Text(vm.instructions.uppercased())
        }
    }
}

#Preview {
    HeaderView()
}
