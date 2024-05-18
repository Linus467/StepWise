//
//  CreationMyTutorials.swift
//  StepWise
//
//  Created by Linus Gierling on 18.05.24.
//

import Foundation
import Combine

class CreationMyTutorialsViewModel : ObservableObject {
    @Published var myTutorialsList: [Tutorial]?
    @Published var errorMessage: String?
    private var userId: String
    private var sessionKey: String
    
    private var api: TutorialCreationAPI = TutorialCreationAPI()
    private var cancellables: Set<AnyCancellable> = []
    
    init(api: TutorialCreationAPI, userId: String, sessionKey: String){
        self.api = api
        self.sessionKey = sessionKey
        self.userId = userId
    }
    
    private func getMyTutorials(){
        
    }
    
}
