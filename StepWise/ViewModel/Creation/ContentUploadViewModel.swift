//
//  ContentUploadViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//


import Combine
import Foundation

class ContentUploadViewModel: ObservableObject {
    private var api: TutorialCreationAPI = TutorialCreationAPI()
    private var cancellables: Set<AnyCancellable> = []
    

    @Published var uploadStatusMessage: String? = ""
    @Published var isUploading: Bool = false

    init(api: TutorialCreationAPI) {
        self.api = api
    }

    func uploadVideo(fileURL: URL,user_id: String, session_key:String, completion: @escaping (Result<URL, Error>) -> Void) {
        isUploading = true
        
        api.uploadVideo(
            fileURL: fileURL,
            user_id: user_id,
            session_key: session_key
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success(let responseURL):
                    self?.uploadStatusMessage = "Video uploaded successfully."
                    completion(.success(URL(string: responseURL)!))
                case .failure(let error):
                    self?.uploadStatusMessage = "Failed to upload video: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }

    func uploadImage(fileURL: URL,user_id: String, session_key:String, completion: @escaping (Result<URL, Error>) -> Void) {
        isUploading = true
        
        api.uploadPicture(assetURL: fileURL,
                          user_id: user_id,
                          session_key: session_key
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success(let responseURL):
                    self?.uploadStatusMessage = "Image uploaded successfully."
                    completion(.success(URL(string: responseURL)!))
                case .failure(let error):
                    self?.uploadStatusMessage = "Failed to upload image: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }
}

