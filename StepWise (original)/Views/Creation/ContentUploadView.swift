//
//  FileUpload.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import SwiftUI

struct ContentUploadView: View {
    @EnvironmentObject private var uiState : GlobalUIState
    @StateObject var viewModel: ContentUploadViewModel
    @State private var showingContentPicker = false
    @State private var fileURL: URL?
    var onFileSelected: (URL) -> Void

    init(viewModel: ContentUploadViewModel, onFileSelected: @escaping (URL) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onFileSelected = onFileSelected
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isUploading {
                    ProgressView("Uploading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                } else {
                    Button("Select Image/Video") {
                        showingContentPicker = true
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                if let message = viewModel.uploadStatusMessage {
                    Text(message)
                        .foregroundColor(viewModel.uploadStatusMessage?.contains("failed") ?? false ? .red : .green)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Upload Content")
            .sheet(isPresented: $showingContentPicker) {
                ContentPicker(selectedFileURL: $fileURL)
                    .onDisappear {
                        if let url = fileURL {
                            if url.lastPathComponent.hasSuffix("mp4") {
                                viewModel.uploadVideo(fileURL: url, user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "") { result in
                                    switch result {
                                    case .success(let uploadedURL):
                                        onFileSelected(uploadedURL)
                                    case .failure(let error):
                                        print("Upload error: \(error)")
                                    }
                                }
                            } else {
                                viewModel.uploadImage(fileURL: url, user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "") { result in
                                    switch result {
                                    case .success(let uploadedURL):
                                        onFileSelected(uploadedURL)
                                    case .failure(let error):
                                        print("Upload error: \(error)")
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
}

struct ContentUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ContentUploadView(viewModel: ContentUploadViewModel(api: TutorialCreationAPI())) { selectedURL in
            print("Selected URL: \(selectedURL)")
        }
    }
}

