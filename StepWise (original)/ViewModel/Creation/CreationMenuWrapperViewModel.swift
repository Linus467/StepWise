//
//  CreationMenuWrapperViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//
import Foundation
import Combine

class CreationMenuWrapperViewModel: ObservableObject {
    @Published var tutorial: Tutorial?
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private var api: TutorialCreationAPI = TutorialCreationAPI()
    
    func fetchTutorial(tutorialId: UUID, user_id: String, session_key: String) {
        isLoading = true
        api.getTutorial(tutorialId: tutorialId, userId: user_id, sessionKey: session_key)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching tutorial: \(error)")
                }
            }, receiveValue: { [weak self] tutorial in
                self?.tutorial = tutorial
                print("Tutorial: received: \(String(describing: self?.tutorial))")
            })
            .store(in: &cancellables)
    }
}
