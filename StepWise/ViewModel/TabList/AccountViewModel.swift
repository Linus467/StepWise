//
//  AccountViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 17.04.24.
//
import Combine
import Foundation

class AccountViewModel: ObservableObject {
    @Published var user = User()
    private var cancellables = Set<AnyCancellable>()
    private let api = AccountAPI()

    func fetchUser(userId: String, sessionKey: String) {
        api.getUser(userId: userId, session_key: sessionKey)
            .receive(on: DispatchQueue.main) 
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] user in
                self?.user = user
                print("user:", user)
            })
            .store(in: &cancellables)
    }
}
