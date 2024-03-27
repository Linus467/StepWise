//
//  Step.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct Step: Identifiable, Decodable {
    var id: UUID
    var title: String
    var subStepList: [SubStep]
}
