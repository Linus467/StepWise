//
//  TutorialTest.swift
//  StepWiseTests
//
//  Created by Linus Gierling on 04.04.24.
//

import Foundation
import XCTest

@testable import StepWise

class TutorialTests: XCTestCase {
    func testFetchTutorials() {
        // Prepare the mock data
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockTutorials", withExtension: "json"),
              let mockData = try? Data(contentsOf: url) else {
            XCTFail("Missing file: MockTutorials.json")
            return
        }

        // Set up the mock session
        let mockSession = MockURLSession()
        mockSession.mockData = mockData
        let viewModel = BrowserViewModel() // Adjust to match your ViewModel's initializer

        let expectation = self.expectation(description: "Fetching tutorials")
         // Ensure this function accepts a URLSession argument for testing

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithError: \(error)")
            }

            // Verify
            XCTAssertNotNil(viewModel.tutorialPreview, "The tutorialPreview should have been populated.")
            XCTAssertEqual(viewModel.tutorialPreview.count, 5) // Replace expectedCount with the actual number of tutorials you expect
        }
    }
}
