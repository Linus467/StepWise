//
//  FavoriteView.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//
import SwiftUI

struct FavoriteView: View {
    @StateObject var viewModel = FavoritesViewModel()
    @EnvironmentObject var uiState: GlobalUIState

    var body: some View {
        VStack {
            if uiState.showListView {
                Text("Favorite")
                    .font(.title.bold())
                    .padding()
            }
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Loading...")
                }
            } else if let errorMessage = viewModel.errorMessage, uiState.debug {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                PreviewListView(tutorialList: viewModel.favoriteTutorials)
            }
        }
        .onAppear {
            if let userId = uiState.user_id, let sessionKey = uiState.session_key {
                viewModel.fetchFavoriteTutorials(userId: userId.description, sessionKey: sessionKey)
            } else {
                viewModel.errorMessage = "User not authenticated."
            }
        }
    }
}

#Preview {
    FavoriteView()
        .environmentObject(GlobalUIState()) // Ensure this contains valid sample data for preview
}
