//
//  TutorialCreationAPI.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//

import Foundation
import Combine

class TutorialCreationAPI {
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
    
    func addContent(tutorialId: String, stepId: String, contentType: Int, content: String) -> AnyPublisher<Bool, Error> {
        let path = "AddContent"
        let parameters: [String: Any] = [
            "tutorial_id": tutorialId,
            "step_id": stepId,
            "type": contentType,
            "content": content
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "POST", body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func deleteContent(tutorialId: String, stepId: String, contentId: String) -> AnyPublisher<Bool, Error> {
        let path = "DeleteContent"
        let headers = [
            "tutorial_id": tutorialId,
            "step_id": stepId,
            "content_id": contentId
        ]
        let request = createURLRequest(path: path, method: "DELETE", headers: headers)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func addStep(tutorialId: String, title: String) -> AnyPublisher<Bool, Error> {
           let path = "AddStep"
           let parameters: [String: Any] = ["tutorial_id": tutorialId, "title": title]
           guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
               return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
           }
           let request = createURLRequest(path: path, method: "POST", body: body)

           return URLSession.shared.dataTaskPublisher(for: request)
               .tryMap { output in
                   guard let httpResponse = output.response as? HTTPURLResponse,
                         httpResponse.statusCode == 200 else {
                       throw URLError(.badServerResponse)
                   }
                   return true
               }
               .eraseToAnyPublisher()
       }
       
       func deleteStep(tutorialId: String, stepId: String) -> AnyPublisher<Bool, Error> {
           let path = "DeleteStep"
           let parameters: [String: Any] = ["tutorial_id": tutorialId, "step_id": stepId]
           guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
               return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
           }
           let request = createURLRequest(path: path, method: "DELETE", body: body)

           return URLSession.shared.dataTaskPublisher(for: request)
               .tryMap { output in
                   guard let httpResponse = output.response as? HTTPURLResponse,
                         httpResponse.statusCode == 200 else {
                       throw URLError(.badServerResponse)
                   }
                   return true
               }
               .eraseToAnyPublisher()
       }

   func addTutorial(parameters: [String: Any]) -> AnyPublisher<Bool, Error> {
       let path = "AddTutorial"
       guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
           return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
       }
       let request = createURLRequest(path: path, method: "POST", body: body)

       return URLSession.shared.dataTaskPublisher(for: request)
           .tryMap { output in
               guard let httpResponse = output.response as? HTTPURLResponse,
                     httpResponse.statusCode == 200 else {
                   throw URLError(.badServerResponse)
               }
               return true
           }
           .eraseToAnyPublisher()
   }

   func deleteTutorial(tutorialId: String) -> AnyPublisher<Bool, Error> {
       let path = "DeleteTutorial"
       let headers = ["tutorial_id": tutorialId]
       let request = createURLRequest(path: path, method: "DELETE", headers: headers)

       return URLSession.shared.dataTaskPublisher(for: request)
           .tryMap { output in
               guard let httpResponse = output.response as? HTTPURLResponse,
                     httpResponse.statusCode == 200 else {
                   throw URLError(.badServerResponse)
               }
               return true
           }
           .eraseToAnyPublisher()
   }
    
    func addMaterial(parameters: [String: Any]) -> AnyPublisher<Bool, Error> {
            let path = "AddMaterial"
            guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            let request = createURLRequest(path: path, method: "POST", body: body)

            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let httpResponse = output.response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return true
                }
                .eraseToAnyPublisher()
        }

    func deleteMaterial(parameters: [String: Any]) -> AnyPublisher<Bool, Error> {
        let path = "DeleteMaterial"
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "DELETE", body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }

    // Tool Methods
    func addTool(parameters: [String: Any]) -> AnyPublisher<Bool, Error> {
        let path = "AddTool"
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "POST", body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }

    func deleteTool(parameters: [String: Any]) -> AnyPublisher<Bool, Error> {
        let path = "DeleteTool"
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "DELETE", body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }

    // Search Link Methods
    func addSearchLink(parameters: [String: Any]) -> AnyPublisher<Bool, Error> {
        let path = "AddSearchLink"
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "POST", body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    func uploadVideo(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/VideoUpload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.uploadTask(with: request, fromFile: fileURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let result = String(data: data, encoding: .utf8) {
                completion(.success(result))
            } else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
            }
        }
        
        task.resume()
    }
    
    func uploadPicture(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/PictureUpload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.uploadTask(with: request, fromFile: fileURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let result = String(data: data, encoding: .utf8) {
                completion(.success(result))
            } else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
            }
        }
        
        task.resume()
    }
   
}
