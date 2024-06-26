//
//  StepWiseApp.swift
//  StepWise
//
//  Created by Linus Gierling on 11.03.24.
//

import SwiftUI
import SwiftData

@main
struct StepWiseApp: App {
    @StateObject private var uiState = GlobalUIState()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
