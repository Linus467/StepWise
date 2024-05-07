//
//  GlobalUIState.swift
//  StepWise
//
//  Created by Linus Gierling on 30.03.24.
//

import SwiftUI

class GlobalUIState: ObservableObject {
    @Published var showListView: Bool = true
    @Published var user_id: UUID? = UUID(uuidString: "03275be5-9481-4895-ae9b-d1b7927d4812") ?? UUID()
    @Published var session_key: String? = "e9cec5fb-c537-4e25-8562-43b16ada3abf"
    @Published var debug: Bool = true
}
