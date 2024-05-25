//
//  TutorialView.swift
//  StepWise
//
//  Created by Linus Gierling on 27.03.24.
//

import SwiftUI

struct CreationStepsView: View {
    var tutorialId: String
    @State private var steps: [Step]
    var stepsTitle = ""
    
    @EnvironmentObject private var uiState : GlobalUIState
    @StateObject var viewModel: CreationMenuViewModel
    
    //tracking current step
    @State private var currentStepIndex : Int? = 0
    @Environment(\.presentationMode) var presentationMode
    
    init(tutorialId: String, steps: [Step], viewModel : CreationMenuViewModel){
        self.tutorialId = tutorialId
        self._steps = State(initialValue: steps.map { step in
            var modifiedStep = step
            modifiedStep.subStepList = modifiedStep.subStepList?.sorted(by: {$0.height ?? -1 > $1.height ?? -1})
            return modifiedStep
        })
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                #if os(macOS)
                Text(stepsTitle)
                    .font(.title)
                #endif
                //Progress bar
                ProgressView(value: Double(currentStepIndex ?? 0) / Double(steps.count-1))
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
                                    CreationSubStepView(
                                        subStep: subStep,
                                        stepId: steps[index].id?.uuidString ?? "",
                                        tutorialId: tutorialId)
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
                                
                                EmptyView()
                                    .padding(.vertical, 30)
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            .tag(index)
                            
                            Spacer()
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchTutorial(tutorialId: UUID(uuidString: tutorialId) ?? UUID(), user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "")
                }
                #if os(iOS)
                //activates Swipe gesture
                .tabViewStyle(PageTabViewStyle())
                #endif
                
            }
            #if os(iOS)
            
            .navigationBarTitle(steps[safe: currentStepIndex]?.title ?? "No Title")
            
            #endif
            
        
        }
    }
        
}
extension Collection {
    subscript(safe index: Index?) -> Element? {
        guard let index = index, indices.contains(index) else { return nil }
        return self[index]
    }
}
