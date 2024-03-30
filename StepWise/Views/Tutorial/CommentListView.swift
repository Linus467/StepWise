//
//  UserCommentListView.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import SwiftUI

struct CommentsListView: View {
    var commentList: [UserComment] = []

    var body: some View {
        NavigationView {
            VStack{
                Text("Comments")
                    .font(.title2)
                    .padding(.top, 5)
                
                Divider()
                
                List(commentList) { userComment in
                    CommentView(userComment: userComment)
                }
                .listStyle(PlainListStyle())
            }
            .padding(.top, -100)
        }
    }
}

struct UserCommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleComments = [
            UserComment(id: UUID(), stepID: UUID(), user: User(id: UUID(), firstName: "John", lastName: "Doe", email: "john.doe@example.com", isCreator: false), text: "This is a sample comment."),
            UserComment(id: UUID(), stepID: UUID(), user: User(id: UUID(), firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", isCreator: false), text: "Another sample comment.")
        ]
        return CommentsListView(commentList: sampleComments)
    }
}
