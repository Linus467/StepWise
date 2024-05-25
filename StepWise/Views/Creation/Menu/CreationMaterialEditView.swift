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
    @EnvironmentObject private var uiState: GlobalUIState
    @Environment(\.presentationMode) var presentationMode
    var tutorialId: UUID
    @State private var title: String
    @State private var amount: String
    @State private var price: String
    @State private var link: String

    init(material: Material, viewModel: CreationMenuViewModel, tutorialId: UUID) {
        self.material = material
        self.viewModel = viewModel
        self.tutorialId = tutorialId
        _title = State(initialValue: material.title ?? "")
        _amount = State(initialValue: "\(material.amount)")
        _price = State(initialValue: "\(material.price)")
        _link = State(initialValue: material.link ?? "")
        if material.title == "DONOTWRITETHIS"{
            presentationMode.wrappedValue.dismiss()
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Material Details").font(.headline).foregroundColor(.blue)) {
                    textFieldWithLabel(label: "Title", text: $title)
                    #if os(macOS)
                    
                    textFieldWithLabel(label: "Amount", text: $amount)
                    textFieldWithLabel(label: "Price ($)", text: $price)
                    #endif
                    #if os(iOS)
                    textFieldWithLabel(label: "Amount", text: $amount, keyboardType: .numberPad)
                    textFieldWithLabel(label: "Price ($)", text: $price, keyboardType: .decimalPad)
                    #endif
                    textFieldWithLabel(label: "Link", text: $link)
                }

                Section {
                    Button("Save Changes", action: saveChanges)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                }
            }
            .navigationTitle("Edit Material")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveChanges()
                    }
                }
                #endif
            }
        }
    }
    #if os(iOS)
    private func textFieldWithLabel(label: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
           HStack {
               Text(label)
                   .foregroundStyle(.secondary)
               Spacer()
               TextField("Enter \(label.lowercased())", text: text)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   #if os(iOS)
                   .keyboardType(keyboardType)
                   #endif
           }
       }
    #endif
    #if os(macOS)
    private func textFieldWithLabel(label: String, text: Binding<String>) -> some View {
           HStack {
               Text(label)
                   .foregroundStyle(.secondary)
               Spacer()
               TextField("Enter \(label.lowercased())", text: text)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   #if os(iOS)
                   .keyboardType(keyboardType)
                   #endif
           }
       }
    #endif

    private func saveChanges() {
        let updatedMaterial = Material(id: material.id, title: title, amount: Int(amount) ?? material.amount, price: Double(price) ?? material.price, link: link)
        viewModel.editMaterial(tutorialId: tutorialId.uuidString, material: updatedMaterial, userId: uiState.user_id?.description ?? "", sessionKey: uiState.session_key?.description ?? "")
        presentationMode.wrappedValue.dismiss()
    }
}
