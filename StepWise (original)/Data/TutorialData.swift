//
//  TutorialData.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import Foundation

struct Tutorial: Identifiable, Decodable, Hashable {
    var id: UUID?
    var title: String?
    var tutorialKind: String?
    var user: User?
    var time: TimeInterval?
    var difficulty: Int?
    var completed: Bool?
    var descriptionText: String?
    var previewPictureLink: URL?
    var previewType: String?
    var views: Int?
    var steps: [Step]?
    var tools: [Tool]?
    var materials: [Material]?
    var ratings: [Rating]?
}

struct Step: Identifiable, Decodable, Hashable {
    var id: UUID?
    var title: String?
    var subStepList: [SubStep]?
    var userComments: [UserComment]?
}

struct SubStep: Identifiable, Decodable, Hashable {
    var id: UUID?
    var type: Int?
    var content: Content?
}

enum Content: Decodable, Hashable {
    case text(TextContent)
    case picture(PictureContent)
    case video(VideoContent)
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let textContent = try? container.decode(TextContent.self) {
            self = .text(textContent)
        } else if let pictureContent = try? container.decode(PictureContent.self) {
            self = .picture(pictureContent)
        } else if let videoContent = try? container.decode(VideoContent.self) {
            self = .video(videoContent)
        } else {
            self = .none
        }
    }
}

struct UserComment: Identifiable, Decodable, Hashable {
    var id: UUID?
    var stepID: UUID?
    var user: User?
    var text: String?
    
    init(id: UUID = UUID(), stepID: UUID = UUID(), user: User = User(), text: String = "") {
        self.id = id
        self.stepID = stepID
        self.user = user
        self.text = text
    }
}

struct Rating: Identifiable, Decodable, Hashable {
    var id: UUID
    var user: User
    var rating: Int
    var text: String
}

struct TextContent: Identifiable, Codable, Hashable {
    var id: UUID
    var contentText: String
}

struct PictureContent: Identifiable, Codable, Hashable {
    var id: UUID
    var pictureLink: URL
}

struct VideoContent: Identifiable, Codable, Hashable {
    var id: UUID
    var videoLink: URL
}

struct Tool: Identifiable, Decodable, Hashable {
    var id: UUID?
    var title: String?
    var amount: Int?
    var link: String?
    var price: Double?
}

struct Material: Identifiable, Decodable, Hashable{
    var id: UUID?
    var title: String?
    var amount: Int?
    var price: Double?
    var link : String?
}
