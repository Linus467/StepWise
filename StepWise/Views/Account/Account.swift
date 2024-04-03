//
//  AccountView.swift
//  StepWise
//
//  Created by Linus Gierling on 02.04.24.
//

import SwiftUI

struct Account: View {
    var user: User?
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                HStack{
                    Text(user != nil ? "\(user!.firstName) \(user!.lastName)": "Account")
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                    
                    //if user is not nil and a creator
                    if(user != nil ? user!.isCreator : false){
                        Text("•")
                            .font(.title)
                        Text("Creator")
                            .foregroundStyle(.blue)
                            .font(.title2)
                            .padding(.top, 2)
                    }
                    Spacer()
                }
                Text(user != nil ? "\(user!.email)" : "")
                Divider()
                List{
                    HStack{
//                        Button("test")
//                            .buttonStyle(PlainButtonStyle())
                    }
                    HStack{
                        
                    }
                }
                .listStyle(PlainListStyle())
                
                
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    Account(
        user: User(id: UUID.init(), firstName: "Linus", lastName: "Gierling", email: "Linusgi@gmx.de", isCreator: true)
    )
}
