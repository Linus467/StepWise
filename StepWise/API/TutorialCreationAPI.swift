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
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Add Tool Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
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

    func addTutorial(parameters: [String: Any], userId: String, sessionKey:String) -> AnyPublisher<Bool, Error> {
       let path = "AddTutorial"
       guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
           return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
       }
        let header : [String: String] = [
            "user-id" : userId,
            "session-key" : sessionKey
        ]
        let request = createURLRequest(path: path, method: "POST", headers: header, body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Add Tutorial Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Server error with status: \(errorMessage)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
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
               guard let httpResponse = output.response as? HTTPURLResponse else {
                   throw NetworkError.badResponse(statusCode: 0)
               }
               switch httpResponse.statusCode {
               case 200:
                   print("Add Tool Successful, HTTP Status Code: \(httpResponse.statusCode)")
                   return true
               case 400...499:
                   let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                   throw NetworkError.serverError(description: "Client error: \(errorMessage)")
               case 500...599:
                   throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode)")
               default:
                   throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
               }
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
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Add Tool Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
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
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Add Tool Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
            }
            .eraseToAnyPublisher()
    

    }

    func addTool(parameters: [String: Any], user_Id: String, session_key: String, tutorial_id: String) -> AnyPublisher<Bool, Error> {
        let path = "AddTool"
        let headers: [String: String] = [
            "user-id": user_Id,
            "session-key": session_key,
            "tutorial-id": tutorial_id
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "POST", headers: headers, body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Add Tool Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
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
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Add Tool Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
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
    
    #if os(iOS)
    func uploadPicture(fileURL: URL, user_id: String, session_key: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Fetch assets of specific media types (images and videos)
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d OR mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)

        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        guard let asset = fetchResult.firstObject else {
            completion(.failure(NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No asset found"])))
            return
        }

        // Request the image data and orientation
        PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) { imageData, dataUTI, orientation, info in
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

            let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let path = json["Path"] as? String {
                            completion(.success(path))
                        } else {
                            print("Error: 'Path' key not found in JSON: \(json)")
                            completion(.failure(NSError(domain: "InvalidResponse", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid or no response from server"])))
                        }
                    } else {
                        print("Error: JSON is not a dictionary: \(String(data: data, encoding: .utf8) ?? "nil")")
                        completion(.failure(NSError(domain: "InvalidResponse", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid or no response from server"])))
                    }
                } catch {
                    print("Error: Unable to parse JSON: \(error.localizedDescription). Response data: \(String(data: data, encoding: .utf8) ?? "nil")")
                    completion(.failure(NSError(domain: "InvalidResponse", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid or no response from server"])))
                }
            }

            task.resume()
        }
    }
    #endif

    #if os(macOS)
    func uploadPicture(assetURL: URL, user_id: String, session_key: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Attempt to load image data directly from the URL
        do {
            let data = try Data(contentsOf: assetURL)
            
            // Prepare to upload the image data
            let url = URL(string: "https://example.com/PictureUpload")!  // Replace with your actual base URL
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
        } catch {
            completion(.failure(error))
        }
    }
    #endif
    func editTutorial(tutorialId: String, updates: [String: Any], user_id: String, session_key: String) -> AnyPublisher<Bool, Error> {
        let path = "EditTutorial"
        
        let headers: [String: String] = [
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
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Edited Tutorial Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode) \(errorMessage)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
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
    
    func getMyTutorials(userId: String, sessionKey: String) -> AnyPublisher<[Tutorial], Error> {
        let path = "myTutorial"
        let headers: [String: String] = [
            "user-id": userId,
            "session-key": sessionKey
        ]
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

    func editMaterial(tutorialId: String, material: Material, userId: String, sessionKey: String) -> AnyPublisher<Bool, Error> {
        let path = "EditMaterial"
        let parameters: [String: Any] = [
            "tutorial-id": tutorialId,
            "material-id": material.id?.description ?? "",
            "title": material.title!,
            "amount": material.amount!,
            "price": material.price!,
            "link": material.link!
        ]
        let headers: [String: String] = [
            "user-id": userId,
            "session-key": sessionKey,
            "tutorial-id" : tutorialId
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "PUT", headers: headers, body: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Edited Material Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode) \(errorMessage)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
            }
            .eraseToAnyPublisher()
    
    }

    func editTool(tutorialId: String, tool: Tool, userId: String, sessionKey: String) -> AnyPublisher<Bool, Error> {
        let path = "EditTool"
        let parameters: [String: Any] = [
            "tutorial-id": tutorialId,
            "tool-id": tool.id.description,
            "title": tool.title,
            "amount": tool.amount,
            "price": tool.price,
            "link": tool.link
        ]
        let headers: [String: String] = [
            "user-id": userId,
            "session-key": sessionKey,
            "tutorial-id" : tutorialId
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let request = createURLRequest(path: path, method: "PUT", headers: headers, body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(statusCode: 0)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("Add Tool Successful, HTTP Status Code: \(httpResponse.statusCode)")
                    return true
                case 400...499:
                    let errorMessage = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                    throw NetworkError.serverError(description: "Client error: \(errorMessage)")
                case 500...599:
                    throw NetworkError.serverError(description: "Server error with status: \(httpResponse.statusCode)")
                default:
                    throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
                }
            }
            .eraseToAnyPublisher()
    

    }

}
enum NetworkError: Error {
    case badURL
    case badResponse(statusCode: Int)
    case serverError(description: String)
}
