//
//  MaterialData.swift
//  StepWise
//
//  Created by Linus Gierling on 27.03.24.
//

import Foundation

struct Material: Identifiable, Decodable{
    var id: UUID
    var title: String
    var amount: Int
    var link : String
}
