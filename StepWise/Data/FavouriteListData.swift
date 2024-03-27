//
//  FavouriteListData.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct Favourite: Identifiable, Decodable {
    var id: UUID
    var tutorialID: UUID
    var userID: UUID
    var dateTime: Date
}
