//
//  EmptyContentViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//
import Foundation
import Combine

class EmptyContentUploadViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var fileURL: URL?
    @Published var isUploading: Bool = false
    @Published var uploadStatusMessage: String = ""
    
    private var api: TutorialCreationAPI = TutorialCreationAPI()
    private var cancellables: Set<AnyCancellable> = []
    
    init(api: TutorialCreationAPI) {
        self.api = api
    }
    
    func uploadContent(tutorialId: String, stepId: String, user_id:String, session_key: String) {
        guard let contentURL = fileURL else {
            uploadTextContent(tutorialId: tutorialId, stepId: stepId, user_id: user_id, session_key: session_key)
            return
        }
        
        uploadFileContent(tutorialId: tutorialId, stepId: stepId,user_id: user_id, session_key: session_key, fileURL: contentURL)
    }
    
    private func uploadTextContent(tutorialId: String, stepId: String, user_id: String, session_key: String) {
        guard !inputText.isEmpty else {
            uploadStatusMessage = "Text content is empty."
            return
        }
        
        isUploading = true
        api.addContent(
            tutorialId: tutorialId,
            stepId: stepId,
            user_id: user_id,
            session_key: session_key,
            contentType: 1,
            content: inputText
        )
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUploading = false
                if case .failure(let error) = completion {
                    self?.uploadStatusMessage = "Failed to upload text: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] success in
                self?.uploadStatusMessage = success ? "Text uploaded successfully." : "Failed to upload text."
            })
            .store(in: &cancellables)
    }
    
    private func uploadFileContent(tutorialId: String, stepId: String,user_id: String, session_key: String, fileURL: URL) {
        isUploading = true
        let contentType = fileURL.pathExtension == "mp4" ? 3 : 2 // 3 for video, 2 for picture
        api.addContent(
            tutorialId: tutorialId,
            stepId: stepId,
            user_id: user_id,
            session_key: session_key,
            contentType: contentType,
            content: fileURL.description)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.uploadStatusMessage = "Uploaded successfully"
                case .failure(let error):
                    self?.uploadStatusMessage = "Failed to add content: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] isSuccess in
                self?.uploadStatusMessage = isSuccess ? "Content added successfully with path: \(fileURL.description)" : "Failed to add content."
            })
            .store(in: &cancellables)
    }
}
