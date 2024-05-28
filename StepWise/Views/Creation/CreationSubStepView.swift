//
//  CreationSubStepView.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import SwiftUI
import AVKit

struct CreationSubStepView: View {
    @EnvironmentObject var uiState: GlobalUIState
    @ObservedObject var viewModel: CreationSubStepViewModel = CreationSubStepViewModel(api: TutorialCreationAPI())
    
    @StateObject var viewModelMenu: CreationMenuViewModel
    var subStep: SubStep
    var stepId: String
    var tutorialId: String
    var body: some View {
        HStack{
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
            Spacer()
            if let contentId = subStep.id {
                Button(action:{
                    viewModel.deleteContent(tutorialId: tutorialId, stepId: stepId, contentId: contentId.uuidString, user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "")
                    viewModelMenu.fetchTutorial(tutorialId: UUID(uuidString: tutorialId) ?? UUID(), user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "")
                }){
                    Image(systemName: "trash.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
}

#Preview{
    CreationSubStepView(viewModel: CreationSubStepViewModel(api: TutorialCreationAPI()), viewModelMenu: CreationMenuViewModel(), subStep: SubStep(), stepId: "323e4567-e89b-12d3-a456-426614174008", tutorialId: "123e4567-e89b-12d3-a456-426614174002")
        .environmentObject(GlobalUIState())
}
