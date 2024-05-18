//
//  MainView.swift		
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var uiState = GlobalUIState()
    var body: some View {
        TabView {
            BrowserView()
                .environmentObject(uiState)
                .tabItem {
                    Label("Browser", systemImage: "globe")
                }
            SearchView()
                .environmentObject(uiState)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            HistoryView()
                .environmentObject(uiState)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            FavoriteView()
                .environmentObject(uiState)
                .tabItem {
                    Label("Favorite", systemImage: "star")
                }
//            Account()
//                .environmentObject(uiState)
//                .tabItem {
//                    Label("Account", systemImage: "person")
//                }
            CreationMenuWrapperView(tutorialId: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174002") ?? UUID())
                .environmentObject(uiState)
                .tabItem {
                    Label("Add", systemImage: "person")
                }
        }
    }
}

#Preview {
    MainView()
}
