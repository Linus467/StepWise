//
//  TutorialData.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct Tutorial: Identifiable, Decodable {
    var id: UUID
    var title: String
    var tutorialKind: String
    var userId: UUID
    var time: TimeInterval
    var difficulty: Int
    var completed: Bool
    var description: String
    var previewPictureLink: URL
    var previewType: String
    var views: Int
    var steps: [Step]
    var tools: [Tool]
    var materials: [Material]
    var ratings: [Rating]
    var userComments: [UserComment]
    var watchHistory: [WatchHistory]
    var favouriteList: [Favourite]
}
