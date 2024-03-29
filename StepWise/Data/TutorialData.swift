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
    var description: String?
    var previewPictureLink: URL?
    var previewType: String?
    var views: Int?
    var steps: [Step]?
    var tools: [Tool]?
    var materials: [Material]?
    var ratings: [Rating]?
    var userComments: [UserComment]?
}

struct Step: Identifiable, Decodable, Hashable {
    var id: UUID?
    var title: String?
    var subStepList: [SubStep]?
}

struct SubStep: Identifiable, Decodable, Hashable {
    var id: UUID?
    var type: Int?
    var content: Content?
}

enum Content: Codable, Hashable {
    case text(TextContent)
    case picture(PictureContent)
    case video(VideoContent)
    
    private enum CodingKeys: String, CodingKey {
        case text
        case picture
        case video
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let textContent = try? container.decodeIfPresent(TextContent.self, forKey: .text) {
            self = .text(textContent)
        } else if let pictureContent = try? container.decodeIfPresent(PictureContent.self, forKey: .picture) {
            self = .picture(pictureContent)
        } else if let videoContent = try? container.decodeIfPresent(VideoContent.self, forKey: .video) {
            self = .video(videoContent)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .text, in: container, debugDescription: "Invalid content type")
        }
    }

    // Encoding function omitted for brevity
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
    var id: UUID
    var title: String
    var amount: Int
    var link: String
}

struct Material: Identifiable, Decodable, Hashable{
    var id: UUID
    var title: String
    var amount: Int
    var link : String
}

