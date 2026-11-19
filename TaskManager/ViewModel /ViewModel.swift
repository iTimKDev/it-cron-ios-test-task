//
//  ViewModel.swift
//  TestTask
//
//

import Foundation

class TaskViewModel {
    var tasks: [ListTaskModel]
    
    var onTaskChanged: (() -> Void)?
    
    let taskService: ServiceTask
    
    init(taskService: ServiceTask) {
        self.taskService = taskService
        self.tasks =  taskService.getAllTasks()
    }
    
    func updateStatus(id: UUID, isCompleted: Bool) throws {
        try taskService.updateStatus(id: id, isCompleted: isCompleted)
        tasks = taskService.getAllTasks()
        onTaskChanged?()
    }

}
