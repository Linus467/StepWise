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
    @EnvironmentObject private var uiState : GlobalUIState
    @Environment(\.presentationMode) var presentationMode
    
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
        if tool.title == "DONOTWRITETHIS"{
            presentationMode.wrappedValue.dismiss()
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tool Details").font(.headline).foregroundColor(.blue)) {
                    VStack(alignment: .leading) {
                        HStack{
                            Text("Title")
                                .foregroundStyle(.secondary)
                            Spacer()
                            TextField("Enter title", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        }
                        
                        HStack {
                            Text("Amount")
                                .foregroundStyle(.secondary)
                            Spacer()
                            TextField("0", text: $amount)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack {
                            Text("Price ($)")
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("0.00", text: $price)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack{
                            Text("Link")
                                .foregroundStyle(.secondary)
                            Spacer()
                            
                            TextField("Enter URL", text: $link)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                
                Section {
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .navigationTitle("Edit Tool")
            .navigationBarItems(trailing: Button("Done") {
                saveChanges()
            })
        }
    }

    private func saveChanges() {
        let updatedTool = Tool(id: tool.id, title: title, amount: Int(amount) ?? tool.amount, link: link, price: Double(price) ?? tool.price)
        viewModel.editTool(tutorialId: tutorialId.uuidString, tool: updatedTool, userId: uiState.user_id?.description ?? "", sessionKey: uiState.session_key?.description ?? "")
        presentationMode.wrappedValue.dismiss()
    }
    
}
