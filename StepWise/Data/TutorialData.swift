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
    var id: UUID
    var title: String
    var amount: Int
    var link: String
}

struct Material: Identifiable, Decodable, Hashable{
    var id: UUID?
    var title: String?
    var amount: Int?
    var price: Double?
    var link : String?
}

extension Tutorial: CustomStringConvertible {
    var description: String {
        var desc = "Tutorial(id: \(id?.uuidString ?? "nil"), title: \(title ?? "nil"))\n"
        desc += "Kind: \(tutorialKind ?? "nil")\n"
        desc += "User: \(user?.firstName ?? "nil") \(user?.lastName ?? "nil")\n"
        desc += "Time: \(String(describing: time))\n"
        desc += "Difficulty: \(String(describing: difficulty))\n"
        desc += "Completed: \(String(describing: completed))\n"
        desc += "Description: \(self.descriptionText ?? "nil")\n"
        desc += "Preview Picture Link: \(previewPictureLink?.absoluteString ?? "nil")\n"
        desc += "Preview Type: \(previewType ?? "nil")\n"
        desc += "Views: \(String(describing: views))\n"

        if let steps = self.steps, !steps.isEmpty {
            desc += "Steps:\n"
            for step in steps {
                desc += "\tStep \(step.id?.uuidString ?? "nil"): \(step.title ?? "nil")\n"
                if let subSteps = step.subStepList, !subSteps.isEmpty {
                    desc += "\tSubSteps:\n"
                    for subStep in subSteps {
                        desc += "\t\tSubStep \(subStep.id?.uuidString ?? "nil"): Type \(subStep.type ?? 0)\n"
                    }
                }
            }
        }

        if let tools = self.tools, !tools.isEmpty {
            desc += "Tools:\n"
            for tool in tools {
                desc += "\tTool \(tool.id.uuidString): \(tool.title), Amount: \(tool.amount), Link: \(tool.link)\n"
            }
        }

        if let materials = self.materials, !materials.isEmpty {
            desc += "Materials:\n"
            for material in materials {
                desc += "\tMaterial \(material.id?.uuidString ?? "nil"): \(material.title ?? "nil"), Amount: \(material.amount ?? 0), Price: \(material.price ?? 0.0), Link: \(material.link ?? "nil")\n"
            }
        }

        if let ratings = self.ratings, !ratings.isEmpty {
            desc += "Ratings:\n"
            for rating in ratings {
                desc += "\tRating by \(rating.user.firstName) \(rating.user.lastName): \(rating.rating), Comment: \(rating.text)\n"
            }
        }

        return desc
    }
}
