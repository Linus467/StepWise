//
//  SwiftUIView.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//

import SwiftUI

struct BrowserView: View {
    @StateObject var viewModel = BrowserViewModel()
    @EnvironmentObject var uiState: GlobalUIState

    var body: some View {
        VStack {
            //MARK: -- Title
            if uiState.showListView {
                Text("Browser")
                    .font(.title.bold())
                    .padding()
            }
            
            //MARK: -- Content
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
        //load content 
        .onAppear {
            viewModel.fetchTutorials()
        }
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView()
            .environmentObject(GlobalUIState())
    }
}
