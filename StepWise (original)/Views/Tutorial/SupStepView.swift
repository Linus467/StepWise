//
//  TutorialSupStepView.swift
//  StepWise
//
//  Created by Linus Gierling on 28.03.24.
//

import SwiftUI
import AVKit

struct SubStepView: View {
    var subStep: SubStep
    
    var body: some View {
        switch subStep.content {
        //MARK: -- Content
        case .text(let textContent):
            Text(textContent.contentText)
        
        //MARK: -- Picture
        case .picture(let pictureContent):
            AsyncImage(url: URL(string: pictureContent.pictureLink.absoluteString)) { imagePhase in
                switch imagePhase {
                case .empty:
                    ProgressView() // Loading indicator while fetching the image
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo") // Fallback image in case of failure
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                @unknown default:
                    EmptyView()
                }
            }
        
        //MARK: -- Video
        case .video(let videoContent):
            if let videoURL = URL(string: videoContent.videoLink.absoluteString) {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        AVPlayer(url: videoURL).play() // Start video playback automatically
                    }
            } else {
                Image(systemName: "play.rectangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        case nil, .some(.none):
            EmptyView()
        }
    }
}
