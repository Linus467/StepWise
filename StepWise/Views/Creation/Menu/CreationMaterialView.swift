//
//  CreationMaterialsView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationMaterialView: View {
    @ObservedObject var viewModel: CreationMenuViewModel
    @EnvironmentObject private var uiState: GlobalUIState
    
    @Binding var selectedMaterial: Material?
    @Binding var showingMaterialEdit: Bool

    var body: some View {
        ForEach(viewModel.tutorial?.materials ?? [], id: \.id) { material in
            Button(material.title ?? "Unnamed Material") {
                self.selectedMaterial = material
                self.showingMaterialEdit = true
            }
            .swipeActions() {
                Button("Delete") {
                    viewModel.deleteMaterial(materialId: material.id ?? UUID(), user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "", tutorial_id: viewModel.tutorial?.id?.description ?? "")
                    refreshMaterials()
                }
                .tint(.red)
            }
        }
        Button(action: {
            let newMaterial = Material(id: UUID(), title: "New Material", amount: Int(10) ?? 0, price: Double(1.0) ?? 0.0, link: " ")
            self.selectedMaterial = newMaterial
            self.showingMaterialEdit = true
            viewModel.addMaterial(material: newMaterial, user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "", tutorial_id: viewModel.tutorial?.id ?? UUID())
            refreshMaterials()
        }) {
            Text("Add New Material")
                .foregroundColor(.blue)
        }
    }
    
    private func refreshMaterials() {
        viewModel.fetchTutorial(tutorialId: viewModel.tutorial?.id ?? UUID(), user_id: uiState.user_id?.description ?? "", session_key: uiState.session_key?.description ?? "")
    }
}
