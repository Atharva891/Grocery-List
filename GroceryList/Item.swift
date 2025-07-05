//
//  Item.swift
//  GroceryList
//
//  Created by Atharva Gaikwad on 10/06/25.
//

import Foundation
import SwiftData

@Model
class Item{
    var title:String
    var isCompleted:Bool
    
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
