//
//  CreationDetailView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationDetailView: View {
    @ObservedObject var viewModel: CreationMenuViewModel
    var tutorial: Tutorial?

    var body: some View {
        Group {
            TextField("Title", text: $viewModel.title)
            TextField("Kind", text: $viewModel.tutorialKind)
            TextField("Estimated Time (hours)", value: $viewModel.time, formatter: NumberFormatter())
            TextField("Difficulty", value: $viewModel.difficulty, formatter: NumberFormatter())
            TextField("Description", text: $viewModel.descriptionText)
            Button("Save Changes") {
                viewModel.updateTutorial()
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
    }
}
