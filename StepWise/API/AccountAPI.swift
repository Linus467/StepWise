//
//  Account.swift
//  StepWise
//
//  Created by Linus Gierling on 20.04.24.
//

import Foundation
import Combine

class AccountAPI {
    private var cancellables = Set<AnyCancellable>()
    private var baseURL: URL
    
    init(baseURL: URL = URL(string: "http://127.0.0.1:5000")!) {
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
    
    func changePassword(userId: String, currentPW: String, newPW: String) -> AnyPublisher<Bool, Error> {
        let path = "/api/change_password"
        let parameters: [String: Any] = ["user_id": userId, "currentPW": currentPW, "newPW": newPW]
        let body = try? JSONSerialization.data(withJSONObject: parameters)
        let request = createURLRequest(path: path, method: "POST", headers: ["Content-Type": "application/json"], body: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SimpleResponse.self, decoder: JSONDecoder())
            .map { $0.success }
            .eraseToAnyPublisher()
    }

    func getSessionKey(userId: String, email: String, password: String) -> AnyPublisher<String?, Error> {
        let path = "/api/get_session_key"
        let headers = ["UserId": userId, "email": email, "password": password]
        let request = createURLRequest(path: path, method: "POST", headers: headers)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SessionKeyResponse.self, decoder: JSONDecoder())
            .map { $0.sessionKey }
            .eraseToAnyPublisher()
    }

    func createAccount(email: String, password: String, firstName: String, lastName: String) -> AnyPublisher<Bool, Error> {
        let path = "/api/create_account"
        let parameters: [String: Any] = ["email": email, "password": password, "firstname": firstName, "lastname": lastName]
        let body = try? JSONSerialization.data(withJSONObject: parameters)
        let request = createURLRequest(path: path, method: "POST", headers: ["Content-Type": "application/json"], body: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String, session_key: String) -> AnyPublisher<User, Error> {
        let path = "/api/GetUser"
        let headers = ["user-id":userId, "session-key":session_key]
        var request = createURLRequest(path: path, method: "GET", headers: headers)
         print(request.httpMethod?.description ?? "" )
        print("All Header Fields" + (request.allHTTPHeaderFields?.description ?? ""))
        
        
         return URLSession.shared.dataTaskPublisher(for: request)
             .tryMap { output in
                 guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                     throw URLError(.badServerResponse)
                 }
                 if let json = try? JSONSerialization.jsonObject(with: output.data, options: []) {
                     print("Received JSON:", json)
                 } else {
                     print("Received data is not a valid JSON.")
                 }
                 return output.data
             }
             .decode(type: User.self, decoder: JSONDecoder())
             .receive(on: DispatchQueue.main)
             .eraseToAnyPublisher()
     }
}

struct SimpleResponse: Codable {
    var success: Bool
}

struct SessionKeyResponse: Codable {
    var sessionKey: String?
}
