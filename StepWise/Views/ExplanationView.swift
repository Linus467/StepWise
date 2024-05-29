//
//  ExplanationNiew.swift
//  StepWise
//
//  Created by Linus Gierling on 24.05.24.


import SwiftUI

struct ExplanationView: View {
    @State private var isAnimating = false
    @EnvironmentObject var uiState: GlobalUIState
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    Text("StepWise")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("Welcome to Our DIY Page!")
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .padding()
                        .cornerRadius(10)
                    Text("Discover exciting projects, creative ideas, and more.")
                        .multilineTextAlignment(.center)
                        .padding()
                        .cornerRadius(10)
                    Text("Do it step by step!")
                        .multilineTextAlignment(.center)
                        .padding()
                        .cornerRadius(10)                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Image("StepWise")
                        .resizable()
                        .cornerRadius(30)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                                isAnimating = true
                            }
                        }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Text("Browse ans search all DIY projects. Select a project to view details.")
                        .padding()
                        .cornerRadius(10)
                    NavigationLink(destination: SearchView()) {
                        ModernCardView(text: "Browse and Search Projects", color: .blue, iconName: "magnifyingglass")
                           
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()

                    Text("Here are your favorite projects. Maybe your next DIY?")
                        .padding()
                        .cornerRadius(10)
                    NavigationLink(destination: FavoriteView()) {
                            ModernCardView(text: "Favorite Projects", color: .orange, iconName: "star")
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Text("My most recently visited projects")
                        .padding()
                        .cornerRadius(10)
                    NavigationLink(destination: HistoryView()) {
                        ModernCardView(text: "History View", color: .green,
                                       iconName: "clock")
       
                    }
                   

                    Spacer()
                }
            }
            .padding(.leading)
            .navigationBarTitle("Explanation", displayMode: .inline)
        }
    }
}


struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView().environmentObject(GlobalUIState())
    }
}


struct ModernCardView: View {
    var text: String
    var color: Color
    var iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()

            Text(text)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .background(color)
        .cornerRadius(30)
        .shadow(color: color.opacity(0.1), radius: 30, x: 0, y: 5)
        .padding(.horizontal)
    }
}
