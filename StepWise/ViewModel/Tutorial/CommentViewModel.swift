//
//  UserCommentViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import SwiftUI
import Combine

class CommentViewModel: ObservableObject {
    @Published var userComments: [UserComment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchUserComments() {
        isLoading = true
        let url = URL(string: "http://127.0.0.1:5000/api/comment")!

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                do {
                    self?.userComments = try JSONDecoder().decode([UserComment].self, from: data)
                } catch {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
}
