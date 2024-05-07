//
//  FavoriteViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//


import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favoriteTutorials: [Tutorial] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let favoritesAPI: FavoritesAPI
    private var cancellables = Set<AnyCancellable>()

    init(favoritesAPI: FavoritesAPI = FavoritesAPI()) {
        self.favoritesAPI = favoritesAPI
    }

    func fetchFavoriteTutorials(userId: String, sessionKey: String) {
        isLoading = true
        favoritesAPI.getFavoriteList(userId: userId, sessionKey: sessionKey)
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
                self?.favoriteTutorials = tutorials
            })
            .store(in: &cancellables)
    }

    func removeFavoriteTutorial(userId: String, sessionKey: String, tutorialId: String) {
        favoritesAPI.removeFavorite(userId: userId, sessionKey: sessionKey, tutorialId: tutorialId)
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
                    // If removal is successful, refresh the list
                    self?.fetchFavoriteTutorials(userId: userId, sessionKey: sessionKey)
                }
            })
            .store(in: &cancellables)
    }
}
