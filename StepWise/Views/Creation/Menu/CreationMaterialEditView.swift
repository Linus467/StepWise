//
//  CreationMaterialEditView.swift
//  StepWise
//
//  Created by Linus Gierling on 23.05.24.
//

import SwiftUI

struct CreationMaterialEditView: View {
    var material: Material
    @ObservedObject var viewModel: CreationMenuViewModel
    var tutorialId: UUID
    @State private var title: String
    @State private var amount: String
    @State private var price: String
    @State private var link: String

    init(material: Material, viewModel: CreationMenuViewModel, tutorialId: UUID) {
        self.material = material
        self.viewModel = viewModel
        self.tutorialId = tutorialId
        _title = State(initialValue: material.title!)
        _amount = State(initialValue: String(describing: material.amount))
        _price = State(initialValue: String(describing: material.price))
        _link = State(initialValue: material.link!)
    }

    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Amount", text: $amount)
            TextField("Price", text: $price)
            TextField("Link", text: $link)
            Button("Save Changes") {
                let updatedMaterial = Material(title: title, amount: Int(amount) ?? material.amount, price: Double(price) ?? material.price, link: link)
                viewModel.editMaterial(tutorialId: tutorialId.uuidString, material: updatedMaterial, userId: "userID", sessionKey: "sessionKey")
            }
        }
    }
}
