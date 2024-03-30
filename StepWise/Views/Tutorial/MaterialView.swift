//
//  TutorialMaterialView.swift
//  StepWise
//
//  Created by Linus Gierling on 28.03.24.
//

import SwiftUI

struct MaterialView: View {
    var material: Material

    var body: some View {
        HStack{
            Text("\(material.title)")
                .font(.subheadline)
                .padding()
                .foregroundColor(.primary)
            Spacer()
            Text("Qty: \(material.amount)")
                .font(.subheadline)
                .padding()
                .foregroundColor(.primary)
            Image(systemName: "square.stack.3d.down.right")
                .padding(.leading, -15)
            Link(destination: URL(string: material.link) ?? URL(string: "https://example.com")!) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, -10)
    }
}

struct TutorialMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MaterialView(material: Material(id: UUID(), title: "Wood Planks", amount: 10, link: "https://example.com/material/woodplanks"))
            MaterialView(material: Material(id: UUID(), title: "Nails", amount: 50, link: "https://example.com/material/nails"))
        }
    }
}
