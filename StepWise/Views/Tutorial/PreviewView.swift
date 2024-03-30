//
//  TutorialDisplay.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import SwiftUI

struct PreviewView: View {
    @State var tutorial: Tutorial
    var body: some View {
        VStack {
            VStack{
                //tutorial image
                Image(systemName: "video.slash.circle")
                    .resizable()
                    .aspectRatio(16/10,contentMode: .fit)
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 200)
                    .background(.gray)
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                
                //Title Stack
                HStack{
                    Text(tutorial.title ?? "No title")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.leading,10)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", (tutorial.time ?? TimeInterval(0)) / 3600))h")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, -12)
                    
                    Image(systemName: "timer")
                        .padding(.horizontal, 8)
                }
                
                //Views stack
                HStack{
                    Text((tutorial.tutorialKind ?? "-") + " •")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.leading, 10)
                    
                    Text("\(tutorial.views ?? 0) views")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.leading, -3)
                    
                    Spacer()
                    
                    Text("\(tutorial.difficulty ?? 10)")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Image(systemName: "hammer.circle")
                        .padding(.horizontal,8)
                        .padding(.leading, -10)
                }
                //completion rate stack
                if tutorial.completed ?? false{
                    ProgressView(value: 1.0)
                        .padding(.horizontal, 10)
                        .padding(.vertical, -3)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 4)
        }
        .padding(.horizontal, -10)
    }
}


struct TutorialPreviewView_Pre: PreviewProvider {
    static var previews: some View {
        let sampleSubStepsList = [SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID.init(),contentText:"This is an e"))),
                                  SubStep(id: UUID(), type: 1, content: .text(TextContent(id: UUID.init(),contentText:"This is an e")))]
        let sampleSteps = [Step(id: UUID(), title: "Step 1",subStepList: sampleSubStepsList),
                           Step(id: UUID(), title: "Step 2", subStepList: sampleSubStepsList)]
        let sampleTutorial = Tutorial(
            id: UUID(),
            title: "Sample Tutorial",
            tutorialKind: "DIY",
            user: User(),
            time: TimeInterval(10000),
            difficulty: 3,
            completed: true,
            description: "A brief description of the tutorial.",
            previewPictureLink: URL(string: "https://example.com/preview.jpg")!,
            previewType: "Image",
            views: 42,
            steps: sampleSteps,
            tools: [],
            materials: [],
            ratings: [],
            userComments: []
        )
        List{
            PreviewView(tutorial: sampleTutorial)
            PreviewView(tutorial: sampleTutorial)
            
        }
        .padding(.horizontal, 0)
    }
}
