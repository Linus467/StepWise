//
//  CreationMenuViewAlt.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationMenuView: View {
    @StateObject var viewModel: CreationMenuViewModel
    
    init(tutorial: Tutorial){
        _viewModel = StateObject(wrappedValue: CreationMenuViewModel(tutorial: tutorial))
    }
    
    @State private var showingMaterialEdit = false
    @State private var showingToolEdit = false
    @State private var selectedMaterial: Material?
    @State private var selectedTool: Tool?
    
    @State private var newPreviewPictureLink: String = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Header View")) {
                    CreationHeaderView(tutorial: viewModel.tutorial, newPreviewPictureLink: $newPreviewPictureLink)
                }

                Section(header: Text("Detail View")) {
                    CreationDetailView(viewModel: viewModel, tutorial: viewModel.tutorial)
                }

                Section(header: Text("Materials")) {
                    CreationMaterialView(viewModel: viewModel,selectedMaterial: $selectedMaterial, showingMaterialEdit: $showingMaterialEdit)
                }
                Section(header: Text("Tools")){
                    CreationToolView(viewModel: viewModel,  selectedTool: $selectedTool, showingToolEdit: $showingToolEdit)
                }
            }
            .listStyle(GroupedListStyle())
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
    }
}
