//
//  MockURLSession.swift
//  StepWiseTests
//
//  Created by Linus Gierling on 04.04.24.
//
import Foundation

class MockURLSession: URLSession {
    var mockData: Data?
    var mockError: Error?

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = mockData
        let error = mockError
        return MockURLSessionDataTask {
            completionHandler(data, nil, error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
