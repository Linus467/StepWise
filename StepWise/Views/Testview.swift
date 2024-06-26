//
//  Testview.swift
//  StepWise
//
//  Created by Linus Gierling on 29.03.24.
//

import SwiftUI

struct Testview: View {
    var steps: [Step]
    var body: some View {
        TutorialStepsView(steps: steps)
    }
}

struct Testview_Preview: PreviewProvider {
    static var previews: some View {
        Testview(steps: [
            Step(id: UUID(), title: "Step 1: Gather Materials", subStepList: [
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Start by gathering all the necessary materials listed."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Check the material quality."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Arrange materials for easy access."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Double-check the inventory."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Ensure safety equipment is available.")))
            ]),
            Step(id: UUID(), title: "Step 2: Preparing the Wood", subStepList: [
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Measure and mark the cut lines on your wood according to the plan."))),
                SubStep(id: UUID(), type: 2, content: .picture(PictureContent(id: UUID(), pictureLink: URL(string: "https://example.com/woodcutting.jpg")!))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Use safety equipment."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Start cutting the wood as per measurements."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Sand the wood surfaces for smoothness.")))
            ]),
            Step(id: UUID(), title: "Step 3: Assembly", subStepList: [
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Begin assembling the pieces starting from the base upwards."))),
                SubStep(id: UUID(), type: 3, content: .video(VideoContent(id: UUID(), videoLink: URL(string: "https://example.com/assembly.mp4")!))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Refer to the instruction manual for assembly guidance."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Check the alignment after each step of assembly."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Secure the connections with screws or bolts.")))
            ]),
            Step(id: UUID(), title: "Step 4: Completion", subStepList: [
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Begin assembling the pieces starting from the base upwards."))),
                SubStep(id: UUID(), type: 3, content: .video(VideoContent(id: UUID(), videoLink: URL(string: "https://example.com/assembly.mp4")!))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Refer to the instruction manual for assembly guidance."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Check the alignment after each step of assembly."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Secure the connections with screws or bolts.")))
            ])
        ])
    }
}
