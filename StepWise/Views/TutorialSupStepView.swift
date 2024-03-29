//
//  TutorialSupStepView.swift
//  StepWise
//
//  Created by Linus Gierling on 28.03.24.
//
import SwiftUI

struct SubStepView: View {
    var subStep: SubStep
    
    var body: some View {
        switch subStep.content {
        case .text(let textContent):
            Text(textContent.contentText)
        case .picture(let pictureContent):
            // Display a placeholder for picture content
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .video(let videoContent):
            // Display a video icon for video content
            Image(systemName: "play.rectangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .none:
            EmptyView()
        }
    }
}
