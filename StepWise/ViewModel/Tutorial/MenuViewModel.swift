//
//  TutorialMenuViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 28.03.24.
//

import Foundation
import SwiftUI
import Combine

class MenuViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    private let favoritesApi = FavoritesAPI()
    private var userId: String
    private var sessionKey: String
    private var tutorialId: String

    init(userId: String, sessionKey: String, tutorialId: String) {
        self.userId = userId
        self.sessionKey = sessionKey
        self.tutorialId = tutorialId
        checkInitialFavoriteState()
    }

    private func checkInitialFavoriteState() {
        
    }

    func toggleFavorite() {
        if isFavorite {
            removeFavorite()
        } else {
            addFavorite()
        }
    }

    private func addFavorite() {
        favoritesApi.addFavorite(userId: userId, sessionKey: sessionKey, tutorialId: tutorialId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error adding favorite: \(error)")
                }
            }, receiveValue: { [weak self] success in
                if success {
                    self?.isFavorite = true
                }
            })
            .store(in: &cancellables)
    }

    private func removeFavorite() {
        favoritesApi.removeFavorite(userId: userId, sessionKey: sessionKey, tutorialId: tutorialId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error removing favorite: \(error)")
                }
            }, receiveValue: { [weak self] success in
                if success {
                    self?.isFavorite = false
                }
            })
            .store(in: &cancellables)
    }
}
