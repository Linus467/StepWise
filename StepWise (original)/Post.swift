//
//  Post.swift
//  StepWise
//
//  Created by Linus Gierling on 12.03.24.
//

import Foundation

struct Post: Codable, Identifiable {
    var id: Int
    var title: String
    var content: String
}
