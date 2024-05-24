//
//  CreationToolsView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationToolView: View {
    @ObservedObject var viewModel: CreationMenuViewModel
    @EnvironmentObject private var uiState: GlobalUIState
    
    @Binding var selectedTool: Tool?
    @Binding var showingToolEdit: Bool

    var body: some View {
        ForEach(viewModel.tutorial?.tools ?? [], id: \.id) { tool in
            Button(tool.title) {
                self.selectedTool = tool
                self.showingToolEdit = true
            }
            .swipeActions(){
                Button("Delete"){
                    viewModel.deleteTool(toolId: tool.id, user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "", tutorial_id: viewModel.tutorial?.id?.description ?? "")
                    viewModel.fetchTutorial(tutorialId: viewModel.tutorial?.id ?? UUID(), user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "")
                }
            }
        }
        Button(action: {
            let toolUUID: UUID = UUID()
            viewModel.addTool(tool: Tool(id: toolUUID, title: "New Tool", amount: 1, link: "None", price: 1.0), user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "", tutorial_id: viewModel.tutorial?.id?.description ?? "")
            self.selectedTool = Tool(id: toolUUID, title: "New Tool", amount: 1, link: "None", price: 1.0)
            self.showingToolEdit = true
        }) {
            Text("Add New Tool")
                .foregroundColor(.blue)
        }
        
    }
}
