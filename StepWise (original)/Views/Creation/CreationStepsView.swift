//
//  TutorialView.swift
//  StepWise
//
//  Created by Linus Gierling on 27.03.24.
//

import SwiftUI

struct CreationStepsView: View {
    var tutorialId: String
    var steps: [Step]
    var stepsTitle = ""
    //tracking current step
    @State private var currentStepIndex = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                #if os(macOS)
                Text(stepsTitle)
                    .font(.title)
                #endif
                //Progress bar
                ProgressView(value: Double(currentStepIndex) / Double(steps.count-1))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
                
                //MARK: -- Substep View
                //Mutiple views
                TabView(selection: $currentStepIndex) {
                    //Create views for each steps in Tabview
                    ForEach(steps.indices, id: \.self) { index in
                        
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(steps[index].subStepList!) { subStep in
                                    
                                    CreationSubStepView(subStep: subStep,stepId: steps[index].id?.uuidString ?? "",tutorialId: tutorialId)
                                    #if os(macOS)
//                                        .onAppear(){
//                                            stepsTitle = steps[index].title
//                                        }
                                    #endif
                                    
                                    if steps.count != index {
                                        Divider()
                                            .padding(.vertical)
                                    }
                                }
                                EmptyContentView(viewModel: EmptyContentUploadViewModel(api: TutorialCreationAPI()), tutorialId: tutorialId, stepId: steps[index].id?.uuidString ?? "")
                                    .padding(.horizontal, -10)
                                    .padding(.leading, -5)
                                    .padding(.vertical, -15)
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            .tag(index)
                            
                            Spacer()
                        }
                    }
                }
                #if os(iOS)
                //activates Swipe gesture
                .tabViewStyle(PageTabViewStyle())
                #endif
                
            }
            #if os(iOS)
            .navigationBarTitle(steps[currentStepIndex].title ?? "No Title")
            #endif
            
        }
    }
}

struct TutorialCreationStepsView_Previews: PreviewProvider {
    static var previews: some View {
        CreationStepsView(tutorialId: "123e4567-e89b-12d3-a456-426614174002",steps: [
            // Step 1: Gather Materials
            Step(id: UUID(), title: "Step 1: Gather Materials", subStepList: [
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Start by gathering all the necessary materials listed."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Check the material quality."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Arrange materials for easy access."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Double-check the inventory."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Ensure safety equipment is available.")))
            ], userComments: [
//                UserComment(id: UUID(), stepID: UUID(), user: User(), text: "This is a comment."),
//                UserComment(id: UUID(), stepID: UUID(), user: User(), text: "Another comment.")
            ]),
            
            // Step 2: Preparing the Wood
            Step(id: UUID(), title: "Step 2: Preparing the Wood", subStepList: [
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Measure and mark the cut lines on your wood according to the plan."))),
                SubStep(id: UUID(), type: 2, content: .picture(PictureContent(id: UUID(), pictureLink: URL(string: "https://example.com/woodcutting.jpg")!))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Use safety equipment."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Start cutting the wood as per measurements."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Sand the wood surfaces for smoothness.")))
            ], userComments: [
                UserComment(id: UUID(), stepID: UUID(), user: User(id: UUID.init(), firstName: "Hans", lastName: "Peter", email: "sf", isCreator: false), text: "Comment about wood preparation."),
                UserComment(id: UUID(), stepID: UUID(), user: User(id: UUID.init(), firstName: "Wolfgang", lastName: "Strungert", email: " ", isCreator: false), text: "Another comment about wood preparation.")
            ]),
            
            // Step 3: Assembly
            Step(id: UUID(), title: "Step 3: Assembly", subStepList: [
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Begin assembling the pieces starting from the base upwards."))),
                SubStep(id: UUID(), type: 3, content: .video(VideoContent(id: UUID(), videoLink: URL(string: "https://example.com/assembly.mp4")!))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Refer to the instruction manual for assembly guidance."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Check the alignment after each step of assembly."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Secure the connections with screws or bolts.")))
            ], userComments: [
                UserComment(id: UUID(), stepID: UUID(), user: User(), text: "Comment about assembly."),
                UserComment(id: UUID(), stepID: UUID(), user: User(), text: "Another comment about assembly.")
            ]),
            
            // Step 4: Completion
            Step(id: UUID(), title: "Step 4: Completion", subStepList: [
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Begin assembling the pieces starting from the base upwards."))),
                SubStep(id: UUID(), type: 3, content: .video(VideoContent(id: UUID(), videoLink: URL(string: "https://example.com/assembly.mp4")!))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Refer to the instruction manual for assembly guidance."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Check the alignment after each step of assembly."))),
                SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID(), contentText: "Secure the connections with screws or bolts.")))
            ], userComments: [
                UserComment(id: UUID(), stepID: UUID(), user: User(), text: "Comment about completion."),
                UserComment(id: UUID(), stepID: UUID(), user: User(), text: "Another comment about completion.")
            ])
        ])
        .environmentObject(GlobalUIState())
    }
}
