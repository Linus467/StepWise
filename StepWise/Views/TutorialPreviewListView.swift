//
//  TutorialPreviewListView.swift
//  StepWise
//
//  Created by Linus Gierling on 27.03.24.
//

import SwiftUI

struct TutorialPreviewListView: View {
    @StateObject private var viewModel = TutorialPreviewViewModel()
    @State private var selectedTutorial: Tutorial? = nil
    
    var body: some View {
        NavigationSplitView {
            // Sidebar (Master view) now uses List
            List(viewModel.tutorialPreview, id: \.self, selection: $selectedTutorial) { tutorial in
                //Section{
                    Button(action: {
                        self.selectedTutorial = tutorial
                    }) {
                        TutorialPreviewView(tutorial: tutorial)
                    }
                    .buttonStyle(PlainButtonStyle()) // To maintain the button appearance
                    .foregroundStyle(.primary)
                
            }
            .navigationTitle("Tutorials")
            .listStyle(PlainListStyle())
        } detail: {
            ZStack {
                if let selectedTutorial = selectedTutorial {
                    TutorialMenuView(viewModel: TutorialMenuViewModel(), tutorial: selectedTutorial)
                } else {
                    Text("Please select a tutorial")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .overlay(viewModel.isLoading ? ProgressView("Loading...") : nil)
        .task {
            await viewModel.fetchTutorials()
        }
    }
}

#Preview {
    TutorialPreviewListView()
}
