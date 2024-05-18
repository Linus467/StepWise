//
//  TutorialCreationAPI.swift
//  StepWise
//
//  Created by Linus Gierling on 04.05.24.
//

import Foundation
import Combine
import Photos

class TutorialCreationAPI {
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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func addContent(tutorialId: String, stepId: String,user_id: String, session_key: String, contentType: Int, content: String) -> AnyPublisher<Bool, Error> {
        let path = "AddContent"
        let parameters: [String: Any] = [
            "tutorial-id": tutorialId,
            "step-id": stepId,
            "type": contentType,
            "content": content,
        ]
        let headers : [String: String] = [
            "user-id": user_id,
            "session-key": session_key,
            "tutorial-id": tutorialId
        ]
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
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func deleteContent(tutorialId: String, stepId: String, contentId: String, user_id: String, session_key: String) -> AnyPublisher<Bool, Error> {
        let path = "DeleteContent"
        let headers = [
            "tutorial-id": tutorialId,
            "step-id": stepId,
            "content-id": contentId,
            "user-id":user_id,
            "session-key":session_key
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
    
    func addStep(tutorialId: String, title: String, user_id: String, session_key: String) -> AnyPublisher<Bool, Error> {
           let path = "AddStep"
           let parameters: [String: Any] = [
            "tutorial_id": tutorialId,
            "title": title,
            "user-id": user_id,
            "session-key": session_key
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
       
       func deleteStep(tutorialId: String, stepId: String, user_id: String, session_key: String) -> AnyPublisher<Bool, Error> {
           let path = "DeleteStep"
           let parameters: [String: Any] = 
               [
                "tutorial_id": tutorialId,
                "step_id": stepId,
                "user-id": user_id,
                "session-key": session_key
               ]
           let headers : [String : String] = [
                "tutorial_id": tutorialId,
                "step_id": stepId,
                "user-id": user_id,
                "session-key": session_key
           ]
           guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
               return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
           }
           let request = createURLRequest(path: path, method: "DELETE", headers: headers, body: body)

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

   func deleteTutorial(tutorialId: String, user_id: String, session_key: String) -> AnyPublisher<Bool, Error> {
       let path = "DeleteTutorial"
       
       let headers : [String:String] = [
           "user-id": user_id,
           "session-key": session_key,
           "tutorial-id": tutorialId
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
    
    func addMaterial(parameters: [String: Any], user_Id: String, session_key: String, tutorial_id: String) -> AnyPublisher<Bool, Error> {
        let path = "AddMaterial"
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let headers : [String:String] = [
            "user-id":user_Id,
            "session-key": session_key,
            "tutorial-id": tutorial_id
        ]
        let request = createURLRequest(path: path, method: "POST", headers: headers, body: body)

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

    func deleteMaterial(parameters: [String: Any], user_Id: String, session_key: String, tutorial_id: String) -> AnyPublisher<Bool, Error> {
        let path = "DeleteMaterial"
        
        let headers : [String:String] = [
            "user-id":user_Id,
            "session-key": session_key,
            "tutorial-id": tutorial_id
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let request = createURLRequest(path: path, method: "DELETE",headers: headers, body: body)

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
    func addTool(parameters: [String: Any], user_Id: String, session_key: String, tutorial_id: String) -> AnyPublisher<Bool, Error> {
        let path = "AddTool"
        let headers : [String:String] = [
            "user-id":user_Id,
            "session-key": session_key,
            "tutorial-id": tutorial_id
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "POST",headers:headers, body: body)

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

    func deleteTool(parameters: [String: Any], user_Id: String, session_key: String, tutorial_id: String) -> AnyPublisher<Bool, Error> {
        let path = "DeleteTool"
        let headers : [String:String] = [
            "user-id":user_Id,
            "session-key": session_key,
            "tutorial-id": tutorial_id
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "DELETE",headers:headers, body: body)

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
    func uploadVideo(fileURL: URL,user_id: String, session_key: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)VideoUpload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(user_id, forHTTPHeaderField: "user-id")
        request.addValue(session_key, forHTTPHeaderField: "session-key")
        
        let task = URLSession.shared.uploadTask(with: request, fromFile: fileURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let path = json["Path"] as? String else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid or no response from server"])))
                return
            }
            
            completion(.success(path))
        }
        
        task.resume()
    }
    func uploadPicture(assetURL: URL,user_id: String, session_key: String, completion: @escaping (Result<String, Error>) -> Void) {
        // First, resolve the PHAsset from the assetURL
        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil)
        guard let asset = fetchResult.firstObject else {
            completion(.failure(NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No asset found for URL"])))
            return
        }
        
        // Now request the image data for the asset
        PHImageManager.default().requestImageData(for: asset, options: nil) { imageData, dataUTI, orientation, info in
            guard let data = imageData else {
                completion(.failure(NSError(domain: "UploadError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve image data"])))
                return
            }
            
            // Prepare to upload the image data
            let url = URL(string: "\(self.baseURL)PictureUpload")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue(user_id, forHTTPHeaderField: "user-id")
            request.setValue(session_key, forHTTPHeaderField: "session-key")
            
            var body = Data()
            let filename = "filename.jpg"
            let mimeType = "image/jpeg"
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            // Perform the upload
            let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let path = json["Path"] as? String else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid or no response from server"])))
                    return
                }
                
                completion(.success(path))
            }
            
            task.resume()
        }
    }
    func editTutorial(tutorialId: String, updates: [String: Any], user_id: String, session_key: String) -> AnyPublisher<Bool, Error> {
        let path = "EditTutorial"
        
        var headers: [String: String] = [
            "user-id": user_id,
            "session-key": session_key,
            "tutorial-id" : tutorialId
        ]
        
        // Convert updates dictionary to JSON data
        guard let body = try? JSONSerialization.data(withJSONObject: updates) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let request = createURLRequest(path: path, method: "PUT", headers: headers, body: body)
        
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
    
    func getTutorial(tutorialId: UUID, userId: String, sessionKey: String) -> AnyPublisher<Tutorial, Error> {
            guard let url = URL(string: "\(baseURL)tutorial/id/") else {
                fatalError("Invalid URL")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(tutorialId.uuidString, forHTTPHeaderField: "tutorial-id")
            request.addValue(userId, forHTTPHeaderField: "user-id")
            request.addValue(sessionKey, forHTTPHeaderField: "session-key")
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .decode(type: Tutorial.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
    
    
}
