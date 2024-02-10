//
//  Tasks.swift
//  todo-visionos
//

import Foundation



enum TodoItemPriority: Int, Codable {
    case regular = 0
    case high = 1
    case urgent = 2
}

struct TodoItem: Identifiable, Codable, Comparable {
    static func < (lhs: TodoItem, rhs: TodoItem) -> Bool {
        lhs.priority.rawValue > rhs.priority.rawValue
    }
    
    var id = UUID()
    var description: String
    var priority: TodoItemPriority
}

extension TodoItem {
    static let sampleData: [TodoItem] = [
        TodoItem(description: "Get car serviced", priority: .high),
        TodoItem(description: "Go to the grocery store", priority: .regular)
        
    ]
}


