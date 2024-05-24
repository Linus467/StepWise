//
//  CreationDetailView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationDetailView: View {
    @ObservedObject var viewModel: CreationMenuViewModel
    @EnvironmentObject private var uiState : GlobalUIState
    var tutorial: Tutorial?

    var body: some View {
        Form {
            Section(header: Text("Tutorial Details").font(.headline).foregroundColor(.blue)) {
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Kind", text: $viewModel.tutorialKind)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack {
                    Text("Estimated Time (hours)")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("Hours", value: $viewModel.time, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                HStack {
                    Text("Difficulty")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("Difficulty Level", value: $viewModel.difficulty, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                TextField("Description", text: $viewModel.descriptionText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Section {
                Button(action: {
                    viewModel.editTutorial(tutorialId: tutorial?.id?.description ?? "", updates: [
                        "tutorial_kind" : viewModel.$tutorialKind,
                        "title" : viewModel.$title,
                        "difficulty" : viewModel.$difficulty,
                        "description" : viewModel.$descriptionText,
                        "time" : viewModel.time
                    ], user_id: uiState.user_id?.uuidString ?? "", session_key: uiState.session_key?.description ?? "")
                    
                        viewModel.updateTutorial()
                    viewModel.fetchTutorial(tutorialId: viewModel.tutorial?.id ?? UUID(), user_id: uiState.user_id?.description ?? "", session_key: uiState.user_id?.description ?? "")
                }) {
                    Text("Save Changes")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .formStyle(GroupedFormStyle())
        .navigationTitle("Edit Tutorial Details")
        
    }
}
