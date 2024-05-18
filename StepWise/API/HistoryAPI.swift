//
//  HistoryAPI.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//

import Foundation
import Combine

class HistoryAPI {
    private var cancellables = Set<AnyCancellable>()
    private var baseURL: URL
    
    init(baseURL: URL = URL(string: "http://52.28.42.177:80/api/")!) {
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
    
    func getHistoryList(userId: String, sessionKey: String) -> AnyPublisher<[Tutorial], Error> {
        let path = "GetHistoryList"
        let headers = ["user-id": userId, "session-key": sessionKey]
        let request = createURLRequest(path: path, method: "GET", headers: headers)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [Tutorial].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func deleteHistorySingle(userId: String, sessionKey: String, tutorialId: String) -> AnyPublisher<Bool, Error> {
        let path = "DeleteHistorySingle"
        let headers = ["user-id": userId, "session-key": sessionKey, "tutorial_id": tutorialId]
        let request = createURLRequest(path: path, method: "DELETE", headers: headers)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 204 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func deleteHistory(userId: String, sessionKey: String) -> AnyPublisher<Bool, Error> {
        let path = "DeleteHistory"
        let headers = ["user-id": userId, "session-key": sessionKey]
        let request = createURLRequest(path: path, method: "DELETE", headers: headers)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 204 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
}
