//
//  TutorialRatingView.swift
//  StepWise
//
//  Created by Linus Gierling on 28.03.24.
//
import SwiftUI

struct RatingView: View {
    var rating: Rating

    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text("\(rating.user.firstName) \(rating.user.lastName)")
                    .font(.subheadline) // Keeping the font size small for compactness
                    .fontWeight(.semibold)
                
                Spacer()
                HStack {
                    ForEach(0..<5) { star in
                        Image(systemName: star < rating.rating ? "star.fill" : "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 16)
                            .foregroundColor(star < rating.rating ? .yellow : .gray)
                    }
                }
                
            }
            .padding(.vertical, 4)
            Text(rating.text)
                .font(.caption)
                .truncationMode(.tail)
        }
    }
}

struct TutorialRatingView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RatingView(rating: Rating(id: UUID(), user: User(id: UUID(), firstName: "John", lastName: "Doe", email: "johndoe@example.com", isCreator: false), rating: 4, text: "Great tutorial!"))
            RatingView(rating: Rating(id: UUID(), user: User(id: UUID(), firstName: "Jane", lastName: "Smith", email: "janesmith@example.com", isCreator: true), rating: 5, text: "Very helpful, thanks!"))
        }
    }
}
