//
//  CreationToolsView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationToolView: View {
    @ObservedObject var viewModel: CreationMenuViewModel
    
    @Binding var selectedTool: Tool?
    @Binding var showingToolEdit: Bool

    var body: some View {
        ForEach(viewModel.tutorial?.tools ?? [], id: \.id) { tool in
            Button(tool.title) {
                self.selectedTool = tool
                self.showingToolEdit = true
            }
        }
        Button(action: {
            self.selectedTool = Tool(id: UUID(), title: "", amount: 0, link: "", price: 0.0)
            self.showingToolEdit = true
        }) {
            Text("Add New Tool")
                .foregroundColor(.blue)
        }
        
    }
}
