//
//  BrowserAPI.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//

//  BrowserAPI.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//

import Foundation
import Combine

class BrowserAPI {
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
    
    func getBrowser() -> AnyPublisher<[Tutorial], Error> {
        let path = "GetBrowser"
        let request = createURLRequest(path: path, method: "GET")

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
    
    func getBrowserKind(kind: String) -> AnyPublisher<[Tutorial], Error> {
        let path = "GetBrowserKind"
        let headers = ["kind": kind]
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
}
