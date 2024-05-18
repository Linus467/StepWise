//
//  CreationMenuWrapperView.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//
import SwiftUI
import Combine

struct CreationMenuWrapperView: View {
    @StateObject private var viewModel = CreationMenuWrapperViewModel()
    @EnvironmentObject private var uiState: GlobalUIState
    var tutorialId: UUID
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let tutorial = viewModel.tutorial {
                    CreationMenuView(tutorial: tutorial)
                        .navigationBarTitle(tutorial.title ?? "No Title", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    viewModel.fetchTutorial(
                                        tutorialId: tutorialId,
                                        user_id: uiState.user_id?.description ?? "",
                                        session_key: uiState.session_key?.description ?? ""
                                    )
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                }
                            }
                        }
                } else {
                    Text("Failed to load tutorial")
                }
            }
            .onAppear {
                viewModel.fetchTutorial(
                    tutorialId: tutorialId,
                    user_id: uiState.user_id?.description ?? "",
                    session_key: uiState.session_key?.description ?? ""
                )
            }
        }
    }
}

struct CreationMenuWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        CreationMenuWrapperView(tutorialId: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174002") ?? UUID())
            .environmentObject(GlobalUIState())
    }
}
