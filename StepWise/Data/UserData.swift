//
//  UserData.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct User: Identifiable, Decodable {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var isCreator: Bool

    init(id: UUID = UUID(), firstName: String = "", lastName: String = "", email: String = "", isCreator: Bool = false) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isCreator = isCreator
    }
}

struct WatchHistory: Identifiable, Decodable {
    var id: UUID
    var tutorialID: UUID
    var userID: UUID
    var lastWatchedTime: Date
    var completedSteps: Int
}

struct SearchHistory: Identifiable, Decodable {
    var id: UUID
    var searchedText: String
}

struct Favourite: Identifiable, Decodable {
    var id: UUID
    var tutorial: [Tutorial]
    var dateTime: Date
}
