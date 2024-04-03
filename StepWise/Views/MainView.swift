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
        }
    }
}

#Preview {
    MainView()
}