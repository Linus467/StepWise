//
//  ToolEditView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationToolEditView: View {
    var tool: Tool
    @ObservedObject var viewModel: CreationMenuViewModel
    var tutorialId: UUID
    @State private var title: String
    @State private var amount: String
    @State private var price: String
    @State private var link: String

    init(tool: Tool, viewModel: CreationMenuViewModel, tutorialId: UUID) {
        self.tool = tool
        self.viewModel = viewModel
        self.tutorialId = tutorialId
        _title = State(initialValue: tool.title)
        _amount = State(initialValue: "\(tool.amount)")
        _price = State(initialValue: "\(tool.price)")
        _link = State(initialValue: tool.link)
    }

    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Amount", text: $amount)
            TextField("Price", text: $price)
            TextField("Link", text: $link)
            Button("Save Changes") {
                let updatedTool = Tool(id: tool.id, title: title, amount: Int(amount) ?? tool.amount, link: link, price: Double(price) ?? tool.price)
                viewModel.editTool(tutorialId: tutorialId.uuidString, tool: updatedTool, userId: "userID", sessionKey: "sessionKey")
            }
        }
    }
}
