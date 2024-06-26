//
//  CreationMenuViewAlt.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationMenuView: View {
    @StateObject var viewModel: CreationMenuViewModel
    @EnvironmentObject private var uiState : GlobalUIState
    
    init(tutorial: Tutorial){
        _viewModel = StateObject(wrappedValue: CreationMenuViewModel(tutorial: tutorial))
    }
    @State private var showingStepsView = false
    
    @State private var showingMaterialEdit = false
    @State private var showingToolEdit = false
    @State private var selectedTutorial : Tutorial?
    @State private var selectedMaterial: Material? = Material(id: UUID(), title: "DONOTWRITETHIS", amount: Int(1.0), price: 0.0, link: "")
    @State private var selectedTool: Tool? = Tool(id: UUID(), title: "DONOTWRITETHIS", amount: Int(1.0), link: "", price: 0.0)
    
    @State private var showingDetails = false
    @State private var selecteddetails : Tutorial? = nil
    
    @State private var newPreviewPictureLink: String = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Thumbnail")) {
                    CreationHeaderView(tutorial: viewModel.tutorial, viewModel: viewModel, newPreviewPictureLink: $newPreviewPictureLink)
                }
                Section(header: Text("Steps")) {
                    Button("View steps"){
                        self.selectedTutorial = viewModel.tutorial
                        self.showingStepsView = true
                    }
                    .refreshable {
                        viewModel.fetchTutorial(tutorialId: viewModel.tutorial?.id ?? UUID(), user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "")
                    }
                        
                }
                CreationDetailView(viewModel: viewModel, tutorial: viewModel.tutorial)
                    .scaledToFit()
                    .scrollDisabled(true)
                

                Section(header: Text("Materials")) {
                    CreationMaterialView(viewModel: viewModel,selectedMaterial: $selectedMaterial, showingMaterialEdit: $showingMaterialEdit)
                }
                Section(header: Text("Tools")){
                    CreationToolView(viewModel: viewModel,  selectedTool: $selectedTool, showingToolEdit: $showingToolEdit)
                }
                
            }
            #if os(iOS)
                .listStyle(GroupedListStyle())
            #endif
        }
        .sheet(isPresented: $showingMaterialEdit, content: {
            if let material = selectedMaterial {
                CreationMaterialEditView(material: material, viewModel: viewModel, tutorialId: viewModel.tutorial?.id ?? UUID())
            }
        })
        .sheet(isPresented: $showingToolEdit, content: {
            if let tool = selectedTool {
                CreationToolEditView(tool: tool, viewModel: viewModel, tutorialId: viewModel.tutorial?.id ?? UUID())
            }
        })
        .sheet(isPresented: $showingDetails, content: {
            if let detail = selecteddetails{
                CreationDetailView(viewModel: viewModel, tutorial: viewModel.tutorial)
            }
        })
        .navigationDestination(isPresented: $showingStepsView) {
            if let tutorial = selectedTutorial {
                CreationStepsView(tutorialId: tutorial.id?.description ?? "", steps: tutorial.steps ?? [], viewModel: viewModel)
            }
        }
        .refreshable {
            viewModel.fetchTutorial(tutorialId: viewModel.tutorial?.id ?? UUID(), user_id: uiState.user_id?.uuidString ?? "", session_key: uiState.user_id?.uuidString ?? "")
        }
    }
}
