//
//  CreationMenuView.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//
import SwiftUI

struct CreationMenuView: View {
    var tutorial: Tutorial
    @ObservedObject var viewModel: CreationMenuViewModel = CreationMenuViewModel()
    @State private var showingContentPicker = false
    @State private var showMaterials = true
    @State private var showTools = true
    @State private var showSteps = false
    
    // State variables for editing tutorial
    @State private var newTitle: String
    @State private var newKind: String
    @State private var newTime: String
    @State private var newDifficulty: String
    @State private var newDescription: String
    @State private var newPreviewPictureLink: String
    @State private var newPreviewType: String
    
    // State variables for new material
    @State private var newMaterialTitle = ""
    @State private var newMaterialAmount = ""
    @State private var newMaterialPrice = ""
    @State private var newMaterialLink = ""
    
    // State variables for new tool
    @State private var newToolTitle = ""
    @State private var newToolAmount = ""
    @State private var newToolPrice = ""
    @State private var newToolLink = ""
    
    @EnvironmentObject var uiState: GlobalUIState
    
    init(tutorial: Tutorial) {
        self.tutorial = tutorial
        _newTitle = State(initialValue: tutorial.title ?? "")
        _newKind = State(initialValue: tutorial.tutorialKind ?? "")
        _newTime = State(initialValue: String(format: "%.1f", (tutorial.time ?? 0) / 3600))
        _newDifficulty = State(initialValue: "\(tutorial.difficulty ?? 0)")
        _newDescription = State(initialValue: tutorial.descriptionText ?? "")
        _newPreviewPictureLink = State(initialValue: tutorial.previewPictureLink?.absoluteString ?? "")
        _newPreviewType = State(initialValue: tutorial.previewType ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                           showingContentPicker = true
                    }){
                        AsyncImage(url: tutorial.previewPictureLink) { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .edgesIgnoringSafeArea(.all)
                                 .foregroundStyle(.black)
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 200)
                                .background(Color.gray)
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.vertical)
                    .padding(.leading, -10)
                    .sheet(isPresented: $showingContentPicker) {
                         ContentUploadView(
                             viewModel: ContentUploadViewModel(api: TutorialCreationAPI()),
                             onFileSelected: { selectedUrl in
                                 newPreviewPictureLink = selectedUrl.absoluteString
                                 print("\(newPreviewPictureLink)")
                             })
                     }
                    
                    Text("Title")
                        .font(.subheadline)
                        .padding(.vertical, -5)
                    TextField("Title", text: $newTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    
                    Text("Kind")
                        .font(.subheadline)
                        .padding(.vertical, -5)
                    TextField("Kind", text: $newKind)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    
                    Text("Estimated Time (hours)")
                        .font(.subheadline)
                        .padding(.vertical, -5)
                    TextField("Estimated Time (hours)", text: $newTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                        .keyboardType(.decimalPad)
                    
                    Text("Difficulty")
                        .font(.subheadline)
                        .padding(.vertical, -5)
                    TextField("Difficulty", text: $newDifficulty)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                        .keyboardType(.numberPad)
                    
                    Text("Description")
                        .font(.subheadline)
                        .padding(.vertical, -5)
                    TextField("Description", text: $newDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    
                    
                    Button("Save Changes") {
                        var updates: [String: Any] = [:]
                        if !newTitle.isEmpty { updates["title"] = newTitle }
                        if !newKind.isEmpty { updates["tutorial-kind"] = newKind }
                        if let time = Double(newTime) { updates["time"] = time * 3600 }
                        if let difficulty = Int(newDifficulty) { updates["difficulty"] = difficulty }
                        if !newDescription.isEmpty { updates["description"] = newDescription }
                        if !newPreviewPictureLink.isEmpty { updates["preview-picture-link"] = newPreviewPictureLink }
                        if !newPreviewType.isEmpty { updates["preview-type"] = newPreviewType }
                        
                        viewModel.editTutorial(
                            tutorialId: tutorial.id?.uuidString ?? "",
                            updates: updates,
                            user_id: uiState.user_id?.uuidString ?? "",
                            session_key: uiState.session_key?.description ?? ""
                        )
                    }
                }
                .padding()
                
                Divider()
                
                Section(header: Text("Materials")) {
                    if showMaterials {
                        ForEach(tutorial.materials ?? [], id: \.id) { material in
                            CreationMaterialView(material: material, tutorial_id: tutorial.id?.uuidString ?? "")
                                .environmentObject(uiState)
                        }
                    }
                    Text("New Material")
                    TextField("Title", text: $newMaterialTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    TextField("Amount", text: $newMaterialAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                        .keyboardType(.numberPad)
                    TextField("Price", text: $newMaterialPrice)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                        .keyboardType(.decimalPad)
                    TextField("Link", text: $newMaterialLink)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    Button("Add Material") {
                        let newMaterial = Material(
                            id: UUID(),
                            title: newMaterialTitle,
                            amount: Int(newMaterialAmount) ?? 0,
                            price: Double(newMaterialPrice) ?? 0.0,
                            link: newMaterialLink
                        )
                        viewModel.addMaterial(
                            material: newMaterial,
                            user_id: uiState.user_id?.uuidString ?? "",
                            session_key: uiState.session_key?.description ?? "",
                            tutorial_id: tutorial.id?.uuidString ?? ""
                        )
                        newMaterialTitle = ""
                        newMaterialAmount = ""
                        newMaterialPrice = ""
                        newMaterialLink = ""
                    }
                    .disabled(newMaterialTitle.isEmpty || newMaterialAmount.isEmpty || newMaterialPrice.isEmpty || newMaterialLink.isEmpty)
                }
                .padding()
                
                Divider()
                
                Section(header: Text("Tools")) {
                    if showTools {
                        ForEach(tutorial.tools ?? [], id: \.id) { tool in
                            CreationToolView(tool: tool, tutorial_id: tutorial.id?.uuidString ?? "")
                                .environmentObject(uiState)
                        }
                    }
                    Text("New Tool")
                        .font(.title3)
                    TextField("Title", text: $newToolTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    TextField("Amount", text: $newToolAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                        .keyboardType(.numberPad)
                    TextField("Price", text: $newToolPrice)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                        .keyboardType(.decimalPad)
                    TextField("Link", text: $newToolLink)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    Button("Add Tool") {
                        let newTool = Tool(
                            id: UUID(),
                            title: newToolTitle,
                            amount: Int(newToolAmount) ?? 0,
                            link: newToolLink,
                            price: Double(newToolPrice) ?? 0.0
                        )
                        viewModel.addTool(
                            tool: newTool,
                            user_id: uiState.user_id?.uuidString ?? "",
                            session_key: uiState.session_key?.description ?? "",
                            tutorial_id: tutorial.id?.uuidString ?? ""
                        )
                        newToolTitle = ""
                        newToolAmount = ""
                        newToolPrice = ""
                        newToolLink = ""
                    }
                    .disabled(newToolTitle.isEmpty || newToolAmount.isEmpty || newToolPrice.isEmpty || newToolLink.isEmpty)
                }
                .padding()
            }
            .navigationDestination(isPresented: $showSteps) {
                CreationStepsView(tutorialId: tutorial.id?.uuidString ?? "", steps: tutorial.steps ?? [])
            }
            .onAppear {
                uiState.showListView = false
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showSteps = true
                        }) {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
            .onDisappear {
                uiState.showListView = true
            }
        }
    }
}

//MARK: -- Preview
struct TutorialCreationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: UUID(), firstName: "John", lastName: "Doe", email: "john.doe@example.com", isCreator: true)
        
        let sampleTutorial = Tutorial(
            id: UUID(),
            title: "Sample Tutorial",
            tutorialKind: "SwiftUI",
            user: user,
            time: 30,
            difficulty: 3,
            completed: false,
            descriptionText: "This is a sample tutorial demonstrating how to create a SwiftUI app.",
            previewPictureLink: URL(string: "http://localhost:4566/picture/6121d64b-21ae-4e61-887d-369a2704357e.jpg")!,
            previewType: "image",
            views: 100,
            steps: [
                Step(
                    id: UUID(),
                    title: "Step 1",
                    subStepList: [
                        SubStep(id: UUID(), type: 0, content: .text(TextContent(id: UUID(), contentText: "This is step 1 content."))),
                        SubStep(id: UUID(), type: 1, content: .picture(PictureContent(id: UUID(), pictureLink: URL(string: "https://example.com/picture.jpg")!)))
                    ]
                ),
                Step(
                    id: UUID(),
                    title: "Step 2",
                    subStepList: [
                        SubStep(id: UUID(), type: 0, content: .text(TextContent(id: UUID(), contentText: "This is step 2 content."))),
                        SubStep(id: UUID(), type: 2, content: .video(VideoContent(id: UUID(), videoLink: URL(string: "https://example.com/video.mp4")!)))
                    ]
                )
            ],
            tools: [
                Tool(id: UUID(), title: "Tool 1", amount: 1, link: "https://example.com/tool1", price: 5.0),
                Tool(id: UUID(), title: "Tool 2", amount: 2, link: "https://example.com/tool2", price: 5.0)
            ],
            materials: [
                Material(id: UUID(), title: "Material 1", amount: 3, price: 10.0, link: "https://example.com/material1"),
                Material(id: UUID(), title: "Material 2", amount: 1, price: 10.0, link: "https://example.com/material2")
            ],
            ratings: [
                Rating(id: UUID(), user: user, rating: 4, text: "hello"),
                Rating(id: UUID(), user: user, rating: 5, text: "test")
            ]
        )
        
        return CreationMenuView(tutorial: sampleTutorial)
            .environmentObject(GlobalUIState())
    }
}
