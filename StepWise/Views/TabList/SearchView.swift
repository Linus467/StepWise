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
            } else if viewModel.errorMessage != nil{
                Text("No Tutorials found")
                    .font(.title)
                    .padding()
                Spacer()
            } else {
                //MARK: -- Preview
                PreviewListView(tutorialList: $viewModel.tutorialPreview.wrappedValue)
            }
        }
        .environmentObject(uiState)
        .onAppear(){
            uiState.showListView = true
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        
        SearchView()
            .environmentObject(GlobalUIState())
    }
}
