//
//  ContentView.swift
//  StepWise
//
//  Created by Linus Gierling on 11.03.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            // Your content here
            // This could be a switch statement or if-conditions rendering different views based on the selectedTab value
            // Bottom Tab Bar
            VStack {
                Spacer() // Pushes the tab bar to the bottom
                HStack {
                    Button(action: {
                        self.selectedTab = 0
                    }) {
                        //Red house
                        Image(systemName: "house.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    Spacer() // Spaces out the buttons
                    Button(action: {
                        self.selectedTab = 1
                    }) {
                        Image(systemName: "person.fill") // Use your icons
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
//                .background(VisualEffect(blurStyle: .systemMaterialDark)) // Custom background, here with a blur effect
                .cornerRadius(20)
                .padding(.horizontal)
                .shadow(radius: 10)
            }
        }
    }
}

#Preview {
    ContentView()
}
