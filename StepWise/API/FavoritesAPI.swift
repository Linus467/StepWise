//
//  FavoritesAPI.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//
import Foundation
import Combine

struct FavoritesAPI {
    private let baseUrl = "http://52.28.42.177:80/api"

    func getFavoriteList(userId: String, sessionKey: String) -> AnyPublisher<[Tutorial], Error> {
        guard let url = URL(string: "\(baseUrl)/GetFavorite") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(sessionKey, forHTTPHeaderField: "Authorization")
        request.setValue(userId, forHTTPHeaderField: "user-id")
        request.setValue(sessionKey, forHTTPHeaderField: "session-key")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Tutorial].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func removeFavorite(userId: String, sessionKey: String, tutorialId: String) -> AnyPublisher<Bool, Error> {
        guard let url = URL(string: "\(baseUrl)/RemoveFavorite") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(sessionKey, forHTTPHeaderField: "Authorization")
        request.setValue(userId, forHTTPHeaderField: "user-id")
        request.setValue(sessionKey, forHTTPHeaderField: "session-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["tutorial_id": tutorialId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                return responseDict?["success"] as? Bool ?? false
            }
            .eraseToAnyPublisher()
    }
}
