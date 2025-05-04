//
//  DuskView.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//



import SwiftUI


struct DuskView: View {
    @EnvironmentObject var viewModel: TransitionViewModel
    @State private var showNextScreen = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, Color(.displayP3, red: 15/255, green: 5/255, blue: 56/255)]), startPoint: .bottom, endPoint: .top)
            
            VStack {
                Text("Dusk".uppercased())
                    .kerning(10.0)
                    .font(.system(.largeTitle, design: .serif, weight: .black))
                    .foregroundColor(.white)
                    .padding()
                
                Text(viewModel.message)
                    .foregroundColor(.white)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("The night is coming...")
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding()
                
                Text("Tap to continue")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
                    .opacity(0.8)
            }
            .background {
                Rectangle()
                    .stroke(Color(.systemBackground).opacity(0.13), lineWidth: 20)
                    .background(Rectangle().fill(Color(.secondarySystemGroupedBackground).opacity(0.3)))
                    .clipped()
            }
            .onTapGesture {
                viewModel.continueGame()
                showNextScreen = true
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showNextScreen) {
            if viewModel.isFirstNight {
                // Show special first night view for first round
                PlayingView()
            } else {
                // Show news if this is not the first night
                NewsView(viewModel: NewsViewModel())
            }
        }
    }
}




#Preview {
    DuskView()
        .environmentObject(TransitionViewModel())
}
