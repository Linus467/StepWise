//
//  FavoritesAPI.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//

import Foundation
import Combine

class FavoriteAPI {
    private var cancellables = Set<AnyCancellable>()
    private var baseURL: URL

    init(baseURL: URL = URL(string: "http://127.0.0.1:5000/api/")!) {
        self.baseURL = baseURL
    }

    private func createURLRequest(path: String, method: String, headers: [String: String] = [:], body: Data? = nil) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body
        return request
    }
    
    func fetchFavorites(userId: String) -> AnyPublisher<[Tutorial], Error> {
        let path = "GetFavorite"
        let headers = ["user_id": userId]
        let request = createURLRequest(path: path, method: "GET", headers: headers)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [Tutorial].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func removeFavorite(userId: String, tutorialId: String) -> AnyPublisher<Bool, Error> {
        let path = "RemoveFavorite"
        let headers = ["user_id": userId]
        let parameters: [String: Any] = ["tutorial_id": tutorialId]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "POST", headers: headers, body: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: SimpleResponse.self, decoder: JSONDecoder())
            .map { $0.success }
            .eraseToAnyPublisher()
    }
}
