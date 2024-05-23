//
//  CreationMyTutorials.swift
//  StepWise
//
//  Created by Linus Gierling on 18.05.24.
//

import Foundation
import Combine

class CreationMyTutorialsViewModel: ObservableObject {
    @Published var myTutorialsList: [Tutorial]? {
        didSet {
            isLoading = false
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    var userId: String
    var sessionKey: String

    private var api: TutorialCreationAPI
    private var cancellables: Set<AnyCancellable> = []

    init(api: TutorialCreationAPI, userId: String, sessionKey: String) {
        self.api = api
        self.userId = userId
        self.sessionKey = sessionKey
        getMyTutorials()
    }

    func getMyTutorials() {
        isLoading = true
        api.getMyTutorials(userId: userId, sessionKey: sessionKey)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to load tutorials: \(error.localizedDescription)"
                    self?.myTutorialsList = nil
                }
            }, receiveValue: { [weak self] tutorials in
                self?.myTutorialsList = tutorials
            })
            .store(in: &cancellables)
    }
    func addTutorial(parameters: [String: Any]) {
        isLoading = true
        api.addTutorial(parameters: parameters, userId: userId, sessionKey: sessionKey)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.getMyTutorials()
                case .failure(let error):
                    self?.errorMessage = "Failed to add tutorial: \(error.localizedDescription)"
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    func deleteTutorial(tutorialId: String) {
        isLoading = true
        api.deleteTutorial(tutorialId: tutorialId, user_id: userId, session_key: sessionKey)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.getMyTutorials()
                case .failure(let error):
                    self?.errorMessage = "Failed to delete tutorial: \(error.localizedDescription)"
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
