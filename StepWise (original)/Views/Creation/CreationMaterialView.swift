//
//  CreationMaterialView.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//


import SwiftUI

struct CreationMaterialView: View {
    @ObservedObject private var viewModel: CreationMenuViewModel = CreationMenuViewModel()
    @EnvironmentObject private var uiState: GlobalUIState
    var material: Material
    var tutorial_id : String
    var body: some View {
        HStack{
            //MARK: -- NON Edit version
            Text("\(material.title ?? " ")")
                .font(.subheadline)
                .padding()
                .foregroundColor(.primary)
            Spacer()
            Text("Qty: \(material.amount ?? 0)")
                .font(.subheadline)
                .padding()
                .foregroundColor(.primary)
            Image(systemName: "square.stack.3d.down.right")
                .padding(.leading, -15)
            Link(destination: URL(string: material.link ?? "") ?? URL(string: "https://example.com")!) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.blue)
            }
            Button(action: {
                viewModel.deleteMaterial(
                    materialId: material.id ?? UUID(),
                    user_id: uiState.user_id?.description ?? "",
                    session_key: uiState.user_id?.description ?? "",
                    tutorial_id: tutorial_id.description
                )
            }) {
                Image(systemName: "minus.circle")
            }
        }
        .padding(.vertical, -10)
    }
}

struct TutorialCreationMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CreationMaterialView(material: Material(id: UUID(), title: "Wood Planks", amount: 10, price: 10.0, link: "https://example.com/material/woodplanks"), tutorial_id: "123e4567-e89b-12d3-a456-426614174002")
                .environmentObject(GlobalUIState())
            CreationMaterialView(material: Material(id: UUID(), title: "Nails", amount: 50, price: 10.0, link: "https://example.com/material/nails"), tutorial_id: "123e4567-e89b-12d3-a456-426614174002")
                .environmentObject(GlobalUIState())
        }
    }
}
