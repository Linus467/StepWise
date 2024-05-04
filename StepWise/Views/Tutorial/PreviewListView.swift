//
//  TutorialPreviewListView.swift
//  StepWise
//
//  Created by Linus Gierling on 27.03.24.
//

import SwiftUI

struct PreviewListView: View {
    var tutorialList: [Tutorial] = []
    var title : String = ""
    @State private var selectedTutorial: Tutorial? = nil
    
    var body: some View {
        VStack{
            NavigationSplitView {
                List(tutorialList, id: \.self, selection: $selectedTutorial) { tutorial in
                    Button(action: {
                        self.selectedTutorial = tutorial
                    }) {
                        PreviewView(tutorial: tutorial)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundStyle(.primary)
                }
                .listStyle(PlainListStyle())
            } detail: {
                ZStack {
                    if let selectedTutorial = selectedTutorial {
                        MenuView(viewModel: MenuViewModel(), tutorial: selectedTutorial)
                    } else {
                        Text("Please select a tutorial")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    PreviewListView(tutorialList: [
        Tutorial(id: UUID(), title: "Tutorial 1", tutorialKind: "Kind 1", user: User(id: UUID(), firstName: "John", lastName: "Doe", email: "john@example.com", isCreator: true), time: 1200, difficulty: 3, completed: false, descriptionText: "This is tutorial 1 description", previewPictureLink: URL(string: "https://example.com/tutorial1.jpg")!, previewType: "image", views: 500, steps: [], tools: [], materials: [], ratings: []),
        Tutorial(id: UUID(), title: "Tutorial 2", tutorialKind: "Kind 2", user: User(id: UUID(), firstName: "Jane", lastName: "Doe", email: "jane@example.com", isCreator: false), time: 1500, difficulty: 2, completed: true, descriptionText: "This is tutorial 2 description", previewPictureLink: URL(string: "https://example.com/tutorial2.jpg")!, previewType: "image", views: 800, steps: [], tools: [], materials: [], ratings: [])
    ], title: "Preview Tutorials")
        .environmentObject(GlobalUIState())
}
