//
//  HistoryView.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel = HistoryViewModel()
    @EnvironmentObject var uiState: GlobalUIState

    var body: some View {
        VStack {
            if uiState.showListView {
                Text("History")
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
            viewModel.fetchTutorials(userId: uiState.user_id?.description ?? " ", sessionKey: uiState.session_key?.description ?? " ")
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(GlobalUIState())

}
