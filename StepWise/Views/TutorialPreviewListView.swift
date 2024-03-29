//
//  TutorialPreviewListView.swift
//  StepWise
//
//  Created by Linus Gierling on 27.03.24.
//

import SwiftUI

struct TutorialPreviewListView: View {
    @StateObject private var viewModel = TutorialPreviewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.tutorialPreview) { tutorial in
                        NavigationLink(value: tutorial){
                            TutorialPreviewView(tutorial: tutorial)
                                .padding(.vertical, 5)
                        }
                        .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 0)
            }
            .navigationTitle("Tutorials")
            .onAppear {
                viewModel.fetchTutorials()
            }
            .overlay(viewModel.isLoading ? ProgressView("Loading...") : nil)
            
        }
        .navigationDestination(for: Tutorial.self){ tutorial in
            TutorialMenuView(viewModel: TutorialMenuViewModel(), tutorial: tutorial)
        }
    }
}

#Preview {
    TutorialPreviewListView()
}
