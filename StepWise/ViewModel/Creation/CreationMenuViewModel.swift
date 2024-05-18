//
//  CreationMenuViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import Foundation
import Combine

class CreationMenuViewModel: ObservableObject {
    private var api: TutorialCreationAPI = TutorialCreationAPI()
    private var cancellables = Set<AnyCancellable>()
    
    
    init(api: TutorialCreationAPI) {
        self.api = api
    }
    init(){
        
    }
    func editTutorial(tutorialId: String, updates: [String: Any], user_id: String, session_key: String) {
        api.editTutorial(tutorialId: tutorialId, updates: updates, user_id: user_id, session_key: session_key)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Handle completion
                    break
                case .failure(let error):
                    // Handle error, could update UI or log
                    print("Error updating tutorial: \(error)")
                }
            }, receiveValue: { success in
                // Handle the success response, could trigger UI update or send a notification
                print("Tutorial updated successfully: \(success)")
            })
            .store(in: &cancellables)
    }
    func addMaterial(material: Material, user_id: String, session_key: String, tutorial_id:String) {
         api.addMaterial(parameters: ["title": material.title!, "amount": material.amount!, "link": material.link!], user_Id: user_id, session_key: session_key, tutorial_id: tutorial_id)
             .sink(receiveCompletion: { completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                     print("Failed to add material: \(error)")
                 }
             }, receiveValue: { success in
                 print("Material added successfully: \(success)")
             })
             .store(in: &cancellables)
     }
     
     // Delete material
     func deleteMaterial(materialId: UUID, user_id: String, session_key: String, tutorial_id:String) {
         api.deleteMaterial(parameters: ["material_id": materialId], user_Id: user_id, session_key: session_key, tutorial_id: tutorial_id)
             .sink(receiveCompletion: { completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                     print("Failed to delete material: \(error)")
                 }
             }, receiveValue: { success in
                 print("Material deleted successfully: \(success)")
             })
             .store(in: &cancellables)
     }
     
     // Add tool
     func addTool(tool: Tool, user_id: String, session_key: String, tutorial_id:String) {
         api.addTool(parameters: ["title": tool.title, "amount": tool.amount, "link": tool.link], user_Id: user_id, session_key: session_key, tutorial_id: tutorial_id)
             .sink(receiveCompletion: { completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                     print("Failed to add tool: \(error)")
                 }
             }, receiveValue: { success in
                 print("Tool added successfully: \(success)")
             })
             .store(in: &cancellables)
     }
     
     // Delete tool
     func deleteTool(toolId: UUID, user_id: String, session_key: String, tutorial_id:String) {
         api.deleteTool(parameters: ["tool_id": toolId], user_Id: user_id, session_key: session_key, tutorial_id: tutorial_id)
             .sink(receiveCompletion: { completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                     print("Failed to delete tool: \(error)")
                 }
             }, receiveValue: { success in
                 print("Tool deleted successfully: \(success)")
             })
             .store(in: &cancellables)
     }
 }
