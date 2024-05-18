//
//  ContentViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 12.03.24.
//

import Foundation

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []

    func fetchPosts() {
        guard let url = URL(string: "http://127.0.0.1:5000/posts") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned from the server")
                return
            }
            
            do {
                let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    self.posts = decodedPosts
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
