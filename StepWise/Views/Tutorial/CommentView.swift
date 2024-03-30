//
//  UserCommentView.swift
//  StepWise
//
//  Created by Linus Gierling on 26.03.24.
//

import SwiftUI

struct CommentView: View {
    @State var userComment: UserComment
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            
            if userComment.user != nil{
                Text(userComment.user!.lastName + " " + userComment.user!.firstName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            Text(userComment.text ?? "Error")
                .font(.caption)
                .multilineTextAlignment(.leading)
        }
        .padding(.leading, 8)
        .shadow(radius: 15)
        .frame(width: 340 , alignment: .leading)
    }
}

struct UserCommentView_Previews: PreviewProvider {
    static var previews: some View {
        let userCommentSample = UserComment(id: UUID.init(), stepID:UUID.init(), user: User(id: UUID.init(), firstName: "Linus", lastName: "Gierling", email: "LinusGi@Gmx.de", isCreator: true), text: "It was a great product asdfjn;" )
        CommentView(userComment: userCommentSample)
    }
}
