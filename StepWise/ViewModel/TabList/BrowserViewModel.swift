//
//  BrowserViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//


import Foundation
import Combine

class BrowserViewModel: ObservableObject {
    @Published var tutorialPreview: [Tutorial] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables: Set<AnyCancellable> = []
    private let browserAPI: BrowserAPI

    init(browserAPI: BrowserAPI = BrowserAPI()) {
        self.browserAPI = browserAPI
    }

    func fetchBrowser() {
        isLoading = true
        browserAPI.getBrowser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                case .finished:
                    self?.isLoading = false
                }
            }) { [weak self] tutorials in
                self?.tutorialPreview = tutorials
            }
            .store(in: &cancellables)
    }
    
    
    func fetchTutorialsByKind(kind: String) {
        isLoading = true
        browserAPI.getBrowserKind(kind: kind)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] tutorials in
                self?.tutorialPreview = tutorials
            })
            .store(in: &cancellables)
    }
}
