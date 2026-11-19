//
//  ServiceTask.swift
//  TestTask
//
//

import Foundation

final class ServiceTask {
    private var taskList: [ListTaskModel]
    
    
    init(taskList: [ListTaskModel]) {
        self.taskList = taskList
    }
    
    func getAllTasks() -> [ListTaskModel] {
        return taskList
    }
    
    func createTask(name: String, description: String, isCompleted: Bool, priority: Priority)  {
        
        let task = ListTaskModel(
            name: name, id: UUID(),
            description: description,
            date: Date(),
            priority: priority,
            isCompleted: isCompleted
        )
        taskList.append(task)
    }
    
    func deleteTask(id: UUID) throws {
        guard !taskList.isEmpty else { throw StorageError.arrayIsEmpty }
        for (index, task) in taskList.enumerated() {
            if task.id == id {
                taskList.remove(at: index)
                return
            }
        }
        throw StorageError.deleteFailed
    }
    func updateStatus(id: UUID, isCompleted: Bool) throws {
        guard !taskList.isEmpty else { throw StorageError.arrayIsEmpty }
        
        for (index, task) in taskList.enumerated() {
            if task.id == id {
                taskList[index].isCompleted = isCompleted
                return
            }
        }
        throw StorageError.updateFailed
    }
    
    func getCompletedTasks() -> [ListTaskModel] {
        guard !taskList.isEmpty == true else { return [] }
        return taskList.filter { $0.isCompleted == true }
    }
    
    func getPriorityTasks(priority: Priority) -> [ListTaskModel] {
        guard !taskList.isEmpty == true else { return [] }
        return taskList.filter { $0.priority == priority }
    }
    
    func getSortDateTasks() -> [ListTaskModel] {
        return taskList.sorted(by: { $0.date > $1.date})
    }
    
    
}
