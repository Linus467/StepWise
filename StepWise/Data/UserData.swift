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
    var passwordHash: String

    init(id: UUID = UUID(), firstName: String = "", lastName: String = "", email: String = "", isCreator: Bool = false, passwordHash: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isCreator = isCreator
        self.passwordHash = passwordHash
    }
}
