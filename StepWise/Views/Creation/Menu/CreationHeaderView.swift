//
//  CreationHeaderView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationHeaderView: View {
    var tutorial: Tutorial?
    @ObservedObject var viewModel : CreationMenuViewModel
    @Binding var newPreviewPictureLink: String
    @EnvironmentObject private var uiState : GlobalUIState
    @State private var showingContentPicker = false

    var body: some View {
        Button(action: {
            showingContentPicker = true
        }) {
            AsyncImage(url: tutorial?.previewPictureLink) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .edgesIgnoringSafeArea(.all)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 200)
                    .background(Color.gray)
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showingContentPicker) {
            ContentUploadView(
                viewModel: ContentUploadViewModel(api: TutorialCreationAPI()),
                onFileSelected: { selectedUrl in
                    newPreviewPictureLink = selectedUrl.absoluteString
                    viewModel.editTutorial(tutorialId: tutorial?.id?.description ?? "", updates: ["preview-picture-link" : newPreviewPictureLink, "preview-type" : "Image"], user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "")
                })
        }
    }
}
