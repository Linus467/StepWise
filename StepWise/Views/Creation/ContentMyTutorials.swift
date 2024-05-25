//
//  ContentMyTutorials.swift
//  StepWise
//
//  Created by Linus Gierling on 18.05.24.
//


import SwiftUI

struct ContentMyTutorials: View {
    @StateObject var viewModel: CreationMyTutorialsViewModel
    @State private var showingAddTutorial = false
    @EnvironmentObject var uiState : GlobalUIState

    var body: some View {
        NavigationStack {
            List {
                if let myTutorials = viewModel.myTutorialsList {
                    ForEach(myTutorials, id: \.id) { tutorial in
                        NavigationLink(destination: CreationMenuView(tutorial: tutorial)) {
                            TutorialRow(tutorial: tutorial)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteTutorial(tutorialId: tutorial.id?.description ?? "")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                } else if viewModel.isLoading {
                    // Display a loading indicator while tutorials are being fetched
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    // Display a message if no tutorials are available
                    Text("No tutorials found")
                }
            }
            .navigationTitle("My Tutorials")
            #if os(iOS)
            .navigationBarItems(trailing: addButton)
            #endif
            .onAppear {
                // Ensure tutorials are loaded when the view appears
                viewModel.getMyTutorials()
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showingAddTutorial) {
                AddTutorialView(isPresented: $showingAddTutorial, viewModel: viewModel)
            }
        }
    }

    private var addButton: some View {
        Button(action: {
            showingAddTutorial = true
        }) {
            Image(systemName: "plus")
        }
    }
}

struct TutorialRow: View {
    let tutorial: Tutorial

    var body: some View {
        VStack(alignment: .leading) {
            Text(tutorial.title ?? "Error Loading")
                .font(.headline)
            Text(tutorial.descriptionText ?? "Error Loading")
                .font(.subheadline)
        }
    }
}


struct AddTutorialView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: CreationMyTutorialsViewModel
    @State private var title: String = ""
    @State private var kind: String = ""
    @State private var time: String = ""
    @State private var difficulty: String = ""
    @State private var description: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Kind", text: $kind)
                TextField("Time (mins)", text: $time)
                #if os(iOS)
                    .keyboardType(.numberPad)
                #endif
                TextField("Difficulty", text: $difficulty)
                TextField("Description", text: $description)

                Button("Add Tutorial") {
                    let parameters = [
                        "title": title,
                        "kind": kind,
                        "time": time,
                        "difficulty": difficulty,
                        "description": description,
                        "user_id": viewModel.userId,
                        
                    ]
                    viewModel.addTutorial(parameters: parameters)
                    isPresented = false
                }
            }
            #if os(iOS)
            .navigationBarTitle("New Tutorial", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
            #endif
        }
    }
}


// Preview
struct ContentMyTutorials_Previews: PreviewProvider {
    static var previews: some View {
        let api = TutorialCreationAPI()
        let viewModel = CreationMyTutorialsViewModel(api: api, userId: "user123", sessionKey: "sessionKeyXYZ")
        ContentMyTutorials(viewModel: viewModel)
    }
}
