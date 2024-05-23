//
//  CreationMaterialsView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationMaterialView: View {
    @ObservedObject var viewModel: CreationMenuViewModel
    
    @Binding var selectedMaterial: Material?
    @Binding var showingMaterialEdit: Bool

    var body: some View {
        ForEach(viewModel.tutorial?.materials ?? [], id: \.id) { material in
            Button(material.title ?? "Unnamed Material") {
                self.selectedMaterial = material
                self.showingMaterialEdit = true
            }
        }
        Button(action: {
            self.selectedMaterial = Material(id: UUID(), title: "", amount: 0, price: 0.0, link: "")
            self.showingMaterialEdit = true
        }) {
            Text("Add New Material")
                .foregroundColor(.blue)
        }
        
    }
}
