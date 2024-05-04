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
    @Published var cl_message: client_message
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""

    private var cancellables: Set<AnyCancellable> = []

    init() {
        cl_message = client_message(client_message: nil)
        $searchQuery
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                print("search Update to \(query)")
                self?.tutorialPreview = []
                self?.errorMessage = nil
                self?.searchTutorials(query: query)
            }
            .store(in: &cancellables)
    }

    func searchTutorials(query: String) {
        isLoading = true
        
        let url = URL(string: "http://127.0.0.1:5000/api/QueryString")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(query, forHTTPHeaderField: "query")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let jsonString = String(data: data, encoding: .utf8) ?? "Invalid JSON string"
                do {
                    self?.tutorialPreview  = try JSONDecoder().decode([Tutorial].self, from: data)
                    //                } catch let DecodingError.keyNotFound(key, context) {
                    //                    self?.errorMessage = "could not find key \(key) in JSON: \(context.debugDescription)" + jsonString
                    //                } catch let DecodingError.valueNotFound(type, context) {
                    //                    self?.errorMessage = "could not find type \(type) in JSON: \(context.debugDescription)" + jsonString
                    //                } catch let DecodingError.typeMismatch(type, context) {
                    //                    self?.errorMessage = "type mismatch for type \(type) in JSON: \(context.debugDescription)" + jsonString
                    //                } catch let DecodingError.dataCorrupted(context) {
                    //                    self?.errorMessage = "data found to be corrupted in JSON: \(context.debugDescription)" + jsonString
                    //                } catch {
                }
                catch{
                    self?.errorMessage = "Error: \(error.localizedDescription)" + jsonString
                }
            }
        }.resume()
    }
}
