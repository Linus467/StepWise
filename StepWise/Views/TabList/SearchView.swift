//
//  SearchView.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//


import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @EnvironmentObject var uiState: GlobalUIState
    @State private var showSearchBar = true
    
    
    var body: some View {
        VStack {
            if uiState.showListView {
                TextField("Search...", text: $viewModel.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            //Data async loading
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Loading...")
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                //MARK: -- Preview
                PreviewListView(tutorialList: viewModel.tutorialPreview)
            }
        }
        .environmentObject(uiState)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        
        SearchView()
            .environmentObject(GlobalUIState())
    }
}
