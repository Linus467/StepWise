//
//  UserPrewiewViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 27.03.24.
//

import SwiftUI
import Combine

class TutorialPreviewViewModel: ObservableObject {
    @Published var tutorialPreview: [Tutorial] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchUserComments() {
        isLoading = true
        guard let url = URL(string: "http://127.0.0.1:5000/api/tutorial") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self?.errorMessage = "No data received from the server"
                    return
                }

                do {
                    self?.tutorialPreview  = try JSONDecoder().decode([Tutorial].self, from: data)
                } catch let error as DecodingError {
                    self?.errorMessage = self?.decodeError(error, data: data)
                } catch {
                    self?.errorMessage = "Unknown error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    private func decodeError(_ error: DecodingError, data: Data) -> String {
        var errorDescription = "Decoding error: "

        switch error {
        case .typeMismatch(_, let context), .valueNotFound(_, let context), .keyNotFound(_, let context), .dataCorrupted(let context):
            errorDescription += context.debugDescription
            if let jsonString = String(data: data, encoding: .utf8) {
                errorDescription.append("\nReceived JSON: \(jsonString)")
            }
        @unknown default:
            errorDescription += "An unknown decoding error occurred."
        }

        return errorDescription
    }
}
