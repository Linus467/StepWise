//
//  TutorialToolView.swift
//  StepWise
//
//  Created by Linus Gierling on 28.03.24.
//

import SwiftUI

struct ToolView: View {
    var tool: Tool

    var body: some View {
        HStack {
            Text(tool.title)
                .font(.subheadline)
                .padding()
                .foregroundColor(.primary)
            Spacer()
            Text("Qty: \(tool.amount)")
                .font(.subheadline)
                .padding()
                .foregroundColor(.primary)
            Image(systemName: "wrench.and.screwdriver.fill") // Tool icon
                .padding(.leading, -15)
            Link(destination: URL(string: tool.link) ?? URL(string: "https://example.com")!) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, -10)
    }
}

struct TutorialToolView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ToolView(tool: Tool(id: UUID(), title: "Hammer", amount: 1, link: "https://example.com/tool/hammer", price: 5.0))
            ToolView(tool: Tool(id: UUID(), title: "Screwdriver", amount: 2, link: "https://example.com/tool/screwdriver", price: 5.0))
        }
    }
}
