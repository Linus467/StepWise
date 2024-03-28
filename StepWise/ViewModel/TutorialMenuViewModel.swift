//
//  TutorialMenuViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 28.03.24.
//

import Foundation
import SwiftUI

class TutorialMenuViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    
    init(){
        
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        print("Tutorial is now \(isFavorite ? "a favorite" : "not a favorite")")
    }
}
