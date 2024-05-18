//
//  CreationToolView.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import SwiftUI

struct CreationToolView: View {
    @ObservedObject private var viewModel: CreationMenuViewModel = CreationMenuViewModel()
    @EnvironmentObject private var uiState: GlobalUIState
    var tool: Tool
    var tutorial_id: String

    var body: some View {
        HStack {
            Text(tool.title ?? "Not Loaded")
                .font(.subheadline)
                .padding()
                .foregroundColor(.primary)
            Spacer()
            Text("Qty: \(tool.amount ?? 0)")
                .font(.subheadline)
                .padding()
                .foregroundColor(.primary)
            Image(systemName: "wrench.and.screwdriver.fill") // Tool icon
                .padding(.leading, -15)
            Link(destination: URL(string: tool.link ?? "Error") ?? URL(string: "https://example.com")!) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.blue)
            }
            Button(action: {
                viewModel.deleteTool(
                    toolId: tool.id ?? UUID(),
                    user_id: uiState.user_id?.description ?? "",
                    session_key: uiState.session_key?.description ?? "",
                    tutorial_id: tutorial_id)
            }) {
                Image(systemName: "minus.circle")
            }
        }
        .padding(.vertical, -10)
    }
}

struct TutorialCreationToolView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CreationToolView(tool: Tool(id: UUID(), title: "Hammer", amount: 1, link: "https://example.com/tool/hammer"), tutorial_id: "123e4567-e89b-12d3-a456-426614174002")
                .environmentObject(GlobalUIState())
            CreationToolView(tool: Tool(id: UUID(), title: "Screwdriver", amount: 2, link: "https://example.com/tool/screwdriver"), tutorial_id: "123e4567-e89b-12d3-a456-426614174002")
                .environmentObject(GlobalUIState())
        }
    }
}
