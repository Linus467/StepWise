//
//  HistoryViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//
import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    @Published var tutorialPreview: [Tutorial] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let historyAPI: HistoryAPI
    private var cancellables = Set<AnyCancellable>()
    
    init(historyAPI: HistoryAPI = HistoryAPI()) {
        self.historyAPI = historyAPI
    }
    
    func fetchTutorials(userId: String, sessionKey: String) {
        isLoading = true
        historyAPI.getHistoryList(userId: userId, sessionKey: sessionKey)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] tutorials in
                self?.tutorialPreview = tutorials
            })
            .store(in: &cancellables)
    }
    
    func deleteSingleTutorialHistory(userId: String, sessionKey: String, tutorialId: String) {
        historyAPI.deleteHistorySingle(userId: userId, sessionKey: sessionKey, tutorialId: tutorialId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    // Handle completion if needed
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] success in
                if success {
                    // If deletion is successful, update the tutorial previews
                    self?.fetchTutorials(userId: userId, sessionKey: sessionKey)
                }
            })
            .store(in: &cancellables)
    }
    
    func deleteAllTutorialHistory(userId: String, sessionKey: String) {
        historyAPI.deleteHistory(userId: userId, sessionKey: sessionKey)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    // Handle completion if needed
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] success in
                if success {
                    // If deletion is successful, update the tutorial previews
                    self?.tutorialPreview = []
                }
            })
            .store(in: &cancellables)
    }
}
