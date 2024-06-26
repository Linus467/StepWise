//
//  TutorialMenuView.swift
//  StepWise
//
//  Created by Linus Gierling on 28.03.24.
//
import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: MenuViewModel
    var tutorial: Tutorial
    @State private var showMaterials = false
    @State private var showTools = false
    @State private var showSteps: Bool = false
    @EnvironmentObject var uiState: GlobalUIState
    
    var body: some View {
        NavigationStack{
            ScrollView {
                //MARK: -- Tutorial Information
                VStack(alignment: .leading, spacing: 10) {
                    AsyncImage(url: tutorial.previewPictureLink){ image in
                        image
                            .resizable()
                            .aspectRatio(16/10, contentMode: .fit)
                            .edgesIgnoringSafeArea(.all)
                    } placeholder: {
                        Image(systemName: "video.slash.circle")
                            .resizable()
                            .aspectRatio(16/10, contentMode: .fit)
                            .scaledToFit()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 200)
                            .background(Color.gray)
                            .cornerRadius(8)
                    }

                    #if os(iOS)
                    Text("Kind: \(tutorial.tutorialKind ?? " ")")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    #endif
                    #if os(macOS)
                    HStack {
                        Text("Kind: \(tutorial.tutorialKind ?? " ")")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                        Button(action: viewModel.toggleFavorite) {
                            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button(action: {
                            showSteps = true
                        }) {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    #endif
                    
                    // Display the tutorial description
                    Text(tutorial.descriptionText ?? "-")
                        .font(.body)
                    
                    // Display user and difficulty
                    if tutorial.user != nil{
                        HStack {
                            Text("Created by: \(tutorial.user!.firstName) \(tutorial.user!.lastName)")
                            Spacer()
                            Text("Difficulty: \(tutorial.difficulty ?? 10)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                   
                    // Display estimated time
                    Text("Estimated Time: \(String(format: "%.1f", (tutorial.time ?? TimeInterval(0)) / 3600))h")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Display number of views
                    Text("Views: \(tutorial.views ?? 0)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                //MARK: -- Material
                Section{
                    Button(action: {
                        withAnimation {
                            showMaterials.toggle()
                        }
                    }) {
                        HStack {
                            Text("Materials")
                            Spacer()
                            Image(systemName: showMaterials ? "chevron.up" : "chevron.down")
                        }
                    }
                    
                    //Material toogle view
                    if showMaterials {
                        ForEach(tutorial.materials ?? [], id: \.id) { material in
                            MaterialView(material: material)
                        }
                    }
                }
                .padding(.horizontal,10)
                .padding(.vertical, 5)
                
                Divider()
                
                //MARK: -- Tools
                Section{
                    Button(action: {
                        withAnimation {
                            showTools.toggle()
                        }
                    }) {
                        HStack {
                            Text("Tools")
                            Spacer()
                            Image(systemName: showTools ? "chevron.up" : "chevron.down")
                        }
                    }
                    
                    //Tools toogle view
                    if showTools {
                        ForEach(tutorial.tools ?? [], id: \.id) { tool in
                            ToolView(tool: tool)
                        }
                    }
                }
                .padding(.horizontal,10)
                .padding(.vertical, 5)
                
                Divider()
                
                //MARK: -- Ratings
                Section{
                    ForEach(tutorial.ratings ?? [], id: \.id) { rating in
                        RatingView(rating: rating)
                    }
                }
                .padding(.horizontal,10)
            }
            //MARK: -- Navgation
            .navigationDestination(isPresented: $showSteps){
                StepsView(steps: tutorial.steps ?? [])
            }
            .navigationTitle(tutorial.title ?? "No Title found")
            #if os(iOS)
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
                        Button(action: viewModel.toggleFavorite) {
                            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
            #endif
            .onAppear(){
                uiState.showListView = false
            }
            .onDisappear(){
                uiState.showListView = true
            }
        }
    }
}

//MARK: -- Preview
struct TutorialMenuView_Previews: PreviewProvider {
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
        var uiState = GlobalUIState()
        return MenuView(
            viewModel: MenuViewModel(
                userId: uiState.user_id?.description ?? " ", sessionKey: uiState.session_key?.description ?? " ", tutorialId: "123e4567-e89b-12d3-a456-426614174002"), tutorial: sampleTutorial)
            .environmentObject(GlobalUIState())
    }
}
