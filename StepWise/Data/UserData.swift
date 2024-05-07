//
//  UserData.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct User: Identifiable, Decodable,  Hashable {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var isCreator: Bool
    
    init(id: UUID = UUID(), firstName: String = "", lastName: String = "", email: String = "", isCreator: Bool = false, watchHistory: [WatchHistory]? = nil, favoriteList: [Favorite]? = nil, searchHistory: [SearchHistory]? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isCreator = isCreator
    }
}

struct WatchHistory: Identifiable, Decodable, Hashable {
    var id: UUID
    var tutorial: Tutorial?
    var userID: UUID
    var lastWatchedTime: Date
    var completedSteps: Int
}

struct SearchHistory: Identifiable, Decodable, Hashable {
    var id: UUID
    var searchedText: String
}

struct Favorite: Identifiable, Decodable, Hashable {
    var id: UUID
    var tutorial: Tutorial?
    var dateTime: Date
}
