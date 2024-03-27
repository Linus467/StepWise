//
//  UserCommentListView.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import SwiftUI

struct UserCommentsListView: View {
    @StateObject private var viewModel = UserCommentViewModel()
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            List(viewModel.userComments) { userComment in
                UserCommentView(userComment: userComment)
            }
            .navigationTitle("Comments")
            .onAppear {
                viewModel.fetchUserComments()
            }
            .overlay(viewModel.isLoading ? ProgressView("Loading...") : nil)
            .onChange(of: viewModel.errorMessage) { newValue in
                showAlert = newValue != nil
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
}

struct UserCommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        UserCommentsListView()
    }
}
