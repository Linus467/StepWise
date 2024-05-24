//
//  CreationMenuViewModel.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import Foundation
import Combine

class CreationMenuViewModel: ObservableObject {
    @Published var tutorial: Tutorial? = Tutorial()
    
    // Proxy variables for editing
    @Published var title: String = ""
    @Published var tutorialKind: String = ""
    @Published var time: TimeInterval = 0
    @Published var difficulty: Int = 0
    @Published var completed: Bool = false
    @Published var descriptionText: String = ""
    @Published var previewPictureLink: URL?
    @Published var previewType: String = ""
    @Published var views: Int = 0
    
    @Published var isLoading = false
    private var api: TutorialCreationAPI = TutorialCreationAPI()
    private var cancellables = Set<AnyCancellable>()
    
    
    init(api: TutorialCreationAPI, tutotrial: Tutorial) {
        self.api = api
        self.tutorial = tutorial
        print("CreationMenuViewModel received Tutorial \(String(describing: tutorial))")
        setupBindings()
    }
    init(tutorial: Tutorial) {
        self.tutorial = tutorial
        print("CreationMenuViewModel received Tutorial \(String(describing: tutorial))")
        setupBindings()
    }
    init(){
        setupBindings()
    }
    private func setupBindings() {
          $tutorial
              .compactMap { $0 }
              .sink { [weak self] tutorial in
                  self?.title = tutorial.title ?? ""
                  self?.tutorialKind = tutorial.tutorialKind ?? ""
                  self?.time = tutorial.time ?? 0
                  self?.difficulty = tutorial.difficulty ?? 0
                  self?.completed = tutorial.completed ?? false
                  self?.descriptionText = tutorial.descriptionText ?? ""
                  self?.previewPictureLink = tutorial.previewPictureLink
                  self?.previewType = tutorial.previewType ?? ""
                  self?.views = tutorial.views ?? 0
              }
              .store(in: &cancellables)
      }

      func updateTutorial() {
          if var updatedTutorial = tutorial {
              updatedTutorial.title = title
              updatedTutorial.tutorialKind = tutorialKind
              updatedTutorial.time = time
              updatedTutorial.difficulty = difficulty
              updatedTutorial.completed = completed
              updatedTutorial.descriptionText = descriptionText
              updatedTutorial.previewPictureLink = previewPictureLink
              updatedTutorial.previewType = previewType
              updatedTutorial.views = views
              
              
              print("Tutorial Updated:", updatedTutorial)
          }
      }
    func fetchTutorial(tutorialId: UUID, user_id: String, session_key: String) {
        isLoading = true
        api.getTutorial(tutorialId: tutorialId, userId: user_id, sessionKey: session_key)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching tutorial: \(error)")
                }
            }, receiveValue: { [weak self] tutorial in
                self?.tutorial = tutorial
                print("Tutorial: received: \(String(describing: self?.tutorial))")
            })
            .store(in: &cancellables)
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
    func addMaterial(material: Material, user_id: String, session_key: String, tutorial_id:UUID) {
        api.addMaterial(parameters: ["title": material.title!, "amount": material.amount!, "link": material.link!, "price" : material.price!], user_Id: user_id, session_key: session_key, tutorial_id: tutorial_id.description)
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
         api.deleteMaterial(parameters: ["material-id": materialId.description], user_Id: user_id, session_key: session_key, tutorial_id: tutorial_id)
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
         api.addTool(parameters: ["title": tool.title, "amount": tool.amount, "link": tool.link, "price": tool.price], user_Id: user_id, session_key: session_key, tutorial_id: tutorial_id)
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
         api.deleteTool(parameters: ["tool-id": toolId.description], user_Id: user_id, session_key: session_key, tutorial_id: tutorial_id)
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
    
    func editMaterial(tutorialId: String, material: Material, userId: String, sessionKey: String) {
        api.editMaterial(tutorialId: tutorialId, material: material, userId: userId, sessionKey: sessionKey)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Successfully updated material.")
                    self?.fetchTutorial(tutorialId: UUID(uuidString: tutorialId) ?? UUID(), user_id: userId, session_key: sessionKey)
                case .failure(let error):
                    print("Error updating material: \(error.localizedDescription)")
                }
            }, receiveValue: { success in
                print("Material update was successful: \(success)")
            })
            .store(in: &cancellables)
    }

    func editTool(tutorialId: String, tool: Tool, userId: String, sessionKey: String) {
        // Assuming Tool properties are guaranteed to be non-nil where this method is called
        api.editTool(tutorialId: tutorialId, tool: tool, userId: userId, sessionKey: sessionKey)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Successfully updated tool.")
                    self?.fetchTutorial(tutorialId: UUID(uuidString: tutorialId) ?? UUID(), user_id: userId, session_key: sessionKey)
                case .failure(let error):
                    print("Error updating tool: \(error.localizedDescription)")
                }
            }, receiveValue: { success in
                print("Tool update was successful: \(success)")
            })
            .store(in: &cancellables)
    }
 }
