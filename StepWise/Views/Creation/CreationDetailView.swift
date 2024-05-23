//
//  CreationDetailView.swift
//  StepWise
//
//  Created by Linus Gierling on 18.05.24.
//

import SwiftUI
import Combine

struct CreationDetailView: View {
    @StateObject var viewModel = CreationMenuViewModel()
    @EnvironmentObject var uiState: GlobalUIState
    
    var tutorialId: String
    
    var body: some View {
        Group {
            if viewModel.isLoading {
            } else if let tutorial = viewModel.tutorial {
                CreationMenuView(tutorial: viewModel.tutorial)
            } else {
                Text("Failed to load tutorial")
            }
        }
        .onAppear {
            viewModel.fetchTutorial(
                tutorialId: UUID(uuidString: tutorialId) ?? UUID(),
                user_id: uiState.user_id?.description ?? "",
                session_key: uiState.session_key?.description ?? ""
            )
        }
        .onReceive(viewModel.$tutorial) { tutorial in
            viewModel.updateTutorial()
        }
        .refreshable {
            viewModel.fetchTutorial(
                tutorialId: UUID(uuidString: tutorialId) ?? UUID(),
                user_id: uiState.user_id?.description ?? "",
                session_key: uiState.session_key?.description ?? ""
            )
        }
    }
}

struct TutorialDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CreationDetailView(tutorialId: "123e4567-e89b-12d3-a456-426614174002")
            .environmentObject(GlobalUIState())
    }
}
