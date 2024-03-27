//
//  UserComment.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct UserComment: Identifiable, Decodable {
    var id: UUID
    var stepID: UUID
    var user: User
    var text: String
    
    init(id: UUID = UUID(), stepID: UUID = UUID(), user: User = User(), text: String = "") {
        self.id = id
        self.stepID = stepID
        self.user = user
        self.text = text
    }
}
