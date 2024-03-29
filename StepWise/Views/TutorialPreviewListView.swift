//
//  TutorialPreviewListView.swift
//  StepWise
//
//  Created by Linus Gierling on 27.03.24.
//

import SwiftUI

struct TutorialPreviewListView: View {
    @StateObject private var viewModel = TutorialPreviewViewModel()
    @State private var showAlert = false
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) { // Adjust spacing between items as needed
                    ForEach(viewModel.tutorialPreview) { tutorial in
                        NavigationLink(destination: TutorialMenuView(tutorial: tutorial)){
                            TutorialPreviewView(tutorial: tutorial)
                                .padding(.vertical, 5)
                        }
                    }
                }
                .padding(.horizontal, 0)
            }
            .navigationTitle("Tutorials")
            .onAppear {
                viewModel.fetchUserComments()
            }
            .overlay(viewModel.isLoading ? ProgressView("Loading...") : nil)
            .onChange(of: viewModel.errorMessage) { newValue in
                showAlert = newValue != nil
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
}

#Preview {
    TutorialPreviewListView()
}
