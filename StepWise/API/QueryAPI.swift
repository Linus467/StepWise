//
//  QueryAPI.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//

import Foundation
import Combine

class QueryAPI {
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
    
    func fetchTutorials(query: String) -> AnyPublisher<[Tutorial], Error> {
        let path = "QueryString"
        let headers = ["query": query]
        let request = createURLRequest(path: path, method: "GET", headers: headers)

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [Tutorial].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
