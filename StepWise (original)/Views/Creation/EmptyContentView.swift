//
//  EmptyContent.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import SwiftUI

struct EmptyContentView: View {
    @EnvironmentObject private var uiState: GlobalUIState
    @StateObject var viewModel : EmptyContentUploadViewModel
    @State private var showingContentPicker = false
    @State private var showContentButton = true
    var tutorialId : String
    var stepId: String

    var body: some View {
        HStack {
            VStack{
                if viewModel.fileURL == nil{
                    if viewModel.inputText.isEmpty{
                        HStack{
                            Text("Add Content")
                                .font(.title3)
                                .padding(.bottom, -20)
                                .padding(.leading, 20)
                            Spacer()
                        }
                    }
                    TextField("Enter some text here...", text: $viewModel.inputText, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
            }
            
            if (showContentButton && viewModel.inputText.isEmpty){
                Button(action: {
                   showingContentPicker = true
               }) {
                   Image(systemName: "photo.on.rectangle.angled")
                       .font(.largeTitle)
               }
                   .padding(.vertical)
                   .padding(.leading, -10)
                   .sheet(isPresented: $showingContentPicker) {
                        ContentUploadView(
                            viewModel: ContentUploadViewModel(api: TutorialCreationAPI()),
                            onFileSelected: { selectedUrl in
                                viewModel.fileURL = selectedUrl
                            })
                    }
                if let url = viewModel.fileURL { // Display the selected file URL if available
                    Text("Selected file: \(url.lastPathComponent)")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            if (viewModel.fileURL != nil || !viewModel.inputText.isEmpty){
                //Button to upload the content
                Button(action: {
                    let adss = uiState.user_id?.description ?? ""
                    viewModel.uploadContent(
                        tutorialId: tutorialId,
                        stepId: stepId,
                        user_id: uiState.user_id?.description ?? "",
                        session_key: uiState.session_key?.description ?? ""
                    )
                }){
                    VStack{
                        Image(systemName: "arrowshape.turn.up.right.circle")
                            .font(.largeTitle)
                        Text("Upload")
                            .font(.footnote)
                    }
                    
                    
                }
                    .padding(.vertical)
                    .padding(.leading, -20)
                    
            }
            if !viewModel.uploadStatusMessage.isEmpty {
                Text(viewModel.uploadStatusMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}


struct EmptyContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyContentView(viewModel: EmptyContentUploadViewModel(api: TutorialCreationAPI()),tutorialId: "123e4567-e89b-12d3-a456-426614174002", stepId: "323e4567-e89b-12d3-a456-426614174008")
            .environmentObject(GlobalUIState())
    }
}
