//
//  CreationSubStepViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import Foundation
import Combine

class CreationSubStepViewModel: ObservableObject {
    @Published var isDeleting: Bool = false
    @Published var deletionStatusMessage: String = ""

    private var api: TutorialCreationAPI = TutorialCreationAPI()
    private var cancellables: Set<AnyCancellable> = []

    init(api: TutorialCreationAPI) {
        self.api = api
    }

    func deleteContent(tutorialId: String, stepId: String, contentId: String, user_id: String, session_key: String) {
        isDeleting = true
        api.deleteContent(
            tutorialId: tutorialId,
            stepId: stepId,
            contentId: contentId,
            user_id: user_id,
            session_key: session_key
        )
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.async {
                    self?.isDeleting = false
                    switch completion {
                    case .finished:
                        self?.deletionStatusMessage = "Content deleted successfully."
                    case .failure(let error):
                        self?.deletionStatusMessage = "Failed to delete content: \(error.localizedDescription)"
                    }
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
