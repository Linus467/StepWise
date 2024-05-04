//
//  AccountView.swift
//  StepWise
//
//  Created by Linus Gierling on 02.04.24.
//

import SwiftUI
import Combine

struct Account: View {
    @EnvironmentObject var uiState: GlobalUIState
    @StateObject var viewModel = AccountViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                HStack{
                    Text(!viewModel.user.firstName.isEmpty ? "\(viewModel.user.firstName) \(viewModel.user.lastName)" : "Account")
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                    
                    if viewModel.user.isCreator {
                        Text("•")
                            .font(.title)
                        Text("Creator")
                            .foregroundStyle(.blue)
                            .font(.title2)
                            .padding(.top, 2)
                    }
                    Spacer()
                }
                Text(viewModel.user.email)
                Divider()
                List{
                    Button("History", systemImage: "clock") {
                        
                    }
                    .font(.title2)
                    .padding(2)
                    
                    Button("Favorites", systemImage: "star") {
                        
                    }
                    .font(.title2)
                    .padding(2)
                    
                    if viewModel.user.isCreator {
                        Button("My Tutorials") {
                            
                        }
                        .font(.title2)
                    }
                }
                .listStyle(PlainListStyle())
                Spacer()
            }
            .padding()
        }
        .onAppear {
            print("uiState: ", uiState.user_id.description + " --- " + uiState.session_key)
            viewModel.fetchUser(userId: uiState.user_id.description, sessionKey: uiState.session_key)
            print("User: " ,$viewModel.user)
        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account()
            .environmentObject(GlobalUIState())
    }
}
