//
//  PictureContentData.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct PictureContent: Identifiable, Decodable {
    var id: UUID
    var pictureLink: URL
}
