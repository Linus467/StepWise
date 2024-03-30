//
//  FavoriteView.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject var viewModel = FavoriteViewModel()
    @EnvironmentObject var uiState: GlobalUIState

    var body: some View {
        VStack {
            if uiState.showListView{
                Text("Favorite")
                    .font(.title.bold())
                    .padding()
            }
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Loading...")
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                
                PreviewListView(tutorialList: viewModel.tutorialPreview)
            }
        }
        .onAppear {
            viewModel.fetchTutorials()
        }
    }
}

#Preview {
    FavoriteView()
        .environmentObject(GlobalUIState())

}
