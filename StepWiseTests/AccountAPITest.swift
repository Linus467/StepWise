//
//  AccountAPITest.swift
//  StepWiseTests
//
//  Created by Linus Gierling on 20.04.24.
//

import XCTest
import Combine
@testable import StepWise

class AccountAPITests: XCTestCase {
    var accountAPI: AccountAPI!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        // Change the baseURL to point to your local server
        accountAPI = AccountAPI(baseURL: URL(string: "http://127.0.0.1:5000")!)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testChangePasswordSuccess() {
        let expectation = self.expectation(description: "ChangePassword completes successfully")

        // Assuming your API returns a JSON object { "success": true } on successful password change
        accountAPI.changePassword(userId: "1234", currentPW: "oldPassword", newPW: "newPassword")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Test failed with error: \(error)")
                }
            }, receiveValue: { success in
                XCTAssertTrue(success)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testGetSessionKeySuccess() {
        let expectation = self.expectation(description: "GetSessionKey completes successfully")

        // Assuming the API returns a session key in a JSON object { "sessionKey": "abc123" }
        accountAPI.getSessionKey(userId: UUID().description, email: "test@example.com", password: "password")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Test failed with error: \(error)")
                }
            }, receiveValue: { sessionKey in
                XCTAssertEqual(sessionKey, "abc123")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testCreateAccountSuccess() {
        let expectation = self.expectation(description: "CreateAccount completes successfully")

        // Assuming the API responds with HTTP status 201 for a successful account creation
        accountAPI.createAccount(email: "new@example.com", password: "newpass", firstName: "John", lastName: "Doe")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Test failed with error: \(error)")
                }
            }, receiveValue: { success in
                XCTAssertTrue(success)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5.0, handler: nil)
    }

}
