//
//  ContentView.swift
//  GroceryList
//
//  Created by Atharva Gaikwad on 10/06/25.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var item: String = ""
    @FocusState private var isFocused: Bool
    let buttonTip = ButtonTip()
    
    init(){
        try? Tips.configure()
    }


    func addEssentialFoods() {
        modelContext.insert(Item(title: "Bakery & Breads", isCompleted: false))
        modelContext.insert(Item(title: "Meat & Seafood", isCompleted: true))
        modelContext.insert(Item(title: "Cereals", isCompleted: .random()))
        modelContext.insert(Item(title: "Pasta & Rice", isCompleted: .random()))
        modelContext.insert(Item(title: "Cheese & Eggs", isCompleted: .random()))
    }

    func deleteItem(_ item: Item) {
        modelContext.delete(item)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    let isCompleted = item.isCompleted // Extract to a local variable
                    let foregroundColor: Color = isCompleted ? Color.accentColor : Color.primary
                    let systemImage: String = isCompleted ? "x.circle" : "checkmark.circle"
                    let tintColor: Color = isCompleted ? .accentColor : .green

                    Text(item.title)
                        .font(.title.weight(.light))
                        .padding(.vertical, 2)
                        .foregroundStyle(foregroundColor)
                        .strikethrough(isCompleted)
                        //.italic(item.isCompleted)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation{
                                    modelContext.delete(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading){
                            Button("Done", systemImage: systemImage){
                                item.isCompleted.toggle()
                            }
                            .tint(tintColor)
                        }
                }
            }
            .navigationTitle("Grocery List")
            .toolbar {
                if items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            addEssentialFoods()
                        } label: {
                            Image(systemName: "carrot")
                        }
                        .popoverTip(buttonTip)
                    }
                }
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(
                        "Empty Cart",
                        systemImage: "cart.circle",
                        description: Text("Add some Items to the shopping list.")
                    )
                }
            }
            .safeAreaInset(edge: .bottom){
                VStack(spacing: 12){
                    TextField("Add new item", text: $item) // Added a prompt for TextField
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(.tertiary)
                        .cornerRadius(12)
                        .font(.title.weight(.light))
                        .focused($isFocused)
                    Button{
                        if !item.isEmpty { // Only add if the text field is not empty
                            let newItem = Item(title: item, isCompleted: false)
                            modelContext.insert(newItem) // Use modelContext.insert
                            item = "" // Clear the text field after adding
                            isFocused = false
                        }
                    } label:{
                        Text("Save")
                            .font(.title.weight(.light))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.extraLarge)
                }
                .padding()
                .background(.bar)
            }
            
        }
    }
}

#Preview {
    let sampleData: [Item] = [
        Item(title: "Bakery & Breads", isCompleted: false),
        Item(title: "Meat & Seafood", isCompleted: true),
        Item(title: "Cereals", isCompleted: .random()),
        Item(title: "Pasta & Rice", isCompleted: .random()),
        Item(title: "Cheese & Eggs", isCompleted: .random()),
    ]
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    for item in sampleData {
        container.mainContext.insert(item)
    }

    return ContentView()
        .modelContainer(container)
}

#Preview("Empty cart") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
