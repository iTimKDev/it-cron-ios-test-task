//
//  ListTaskModel.swift
//  TestTask
//
//

import Foundation

struct ListTaskModel {
    let name: String
    let id: UUID
    let description: String
    let date: Date
    let priority: Priority
    var isCompleted: Bool
    
}

enum Priority {
    case low
    case medium
    case high
}

enum StorageError: Error {
    case invalidCreationFailed
    case updateFailed
    case deleteFailed
    case arrayIsEmpty
}
