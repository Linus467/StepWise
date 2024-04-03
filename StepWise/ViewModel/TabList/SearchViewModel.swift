//
//  SearchViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var tutorialPreview: [Tutorial] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchQuery
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchTutorials(query: query)
            }
            .store(in: &cancellables)
    }
    func searchTutorials(query: String) {
        isLoading = true
        
        var urlComponents = URLComponents(string: "http://127.0.0.1:5000/api/tutorial")!
        
        urlComponents.queryItems = [URLQueryItem(name: "search", value: query)]
        
        guard let url = urlComponents.url else {
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
                
                } catch DecodingError.keyNotFound(let key, let context) {
                    self?.errorMessage = "could not find key \(key) in JSON: \(context.debugDescription)"
                } catch DecodingError.valueNotFound(let type, let context) {
                    self?.errorMessage = "could not find type \(type) in JSON: \(context.debugDescription)"
                } catch DecodingError.typeMismatch(let type, let context) {
                    self?.errorMessage = "type mismatch for type \(type) in JSON: \(context.debugDescription)"
                } catch DecodingError.dataCorrupted(let context) {
                    self?.errorMessage = "data found to be corrupted in JSON: \(context.debugDescription)"
                } catch let error as NSError {
                    self?.errorMessage = "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
