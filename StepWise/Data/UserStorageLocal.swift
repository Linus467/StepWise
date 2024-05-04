//
//  UserStorageLocal.swift
//  StepWise
//
//  Created by Linus Gierling on 18.04.24.
//

import SwiftData
import Foundation

@Model
final class UserStorage {
    @Attribute(.unique) var userID: UUID
    @Attribute var name: String

    init(userID: UUID, name: String) {
        self.userID = userID
        self.name = name
    }
}

