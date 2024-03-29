//
//  ContentView.swift
//  StepWise
//
//  Created by Linus Gierling on 11.03.24.
//

import SwiftUI
import SwiftData

struct MainContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    //@StateObject private var viewModel = PostsViewModel()
    var body: some View {		
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink{
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        Text(items.description)
                        Button("Delete") {
                            modelContext.delete(item)
                        }
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Add to Favourites"){
                            
                        }
                        Button("Delete"){
                            modelContext.delete(item)
                        }
                    }))
                }
                .onDelete(perform: deleteItems)
                
            }
            
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        } .onAppear() {
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    MainContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
