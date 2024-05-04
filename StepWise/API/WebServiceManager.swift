//
//  WebServiceManager.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//

import Foundation
import Combine

class WebServiceManager {
    static let shared = WebServiceManager()

    func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
