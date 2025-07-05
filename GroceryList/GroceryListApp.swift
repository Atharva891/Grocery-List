//
//  GroceryListApp.swift
//  GroceryList
//
//  Created by Atharva Gaikwad on 10/06/25.
//

import SwiftUI
import SwiftData

@main
struct GroceryListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for : Item.self)
        }
    }
}
