//
//  WatchHistoryData.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct WatchHistory: Identifiable, Decodable {
    var id: UUID
    var tutorialID: UUID
    var userID: UUID
    var lastWatchedTime: Date
    var completedSteps: Int
}
