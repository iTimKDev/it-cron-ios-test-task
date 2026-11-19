//
//  TestTaskTests.swift
//  TestTaskTests
//
//

import Foundation
import XCTest
@testable import TestTask

final class TestTaskTests: XCTestCase {
    func testCreateAndGetAllTasks() throws {
        let service = ServiceTask(taskList: [])
        XCTAssertTrue(service.getAllTasks().isEmpty)

        let beforeCreation = Date()
        service.createTask(name: "Задача А", description: "Описание А", isCompleted: false, priority: .high)
        service.createTask(name: "Задача Б", description: "Описание Б", isCompleted: true, priority: .low)
        let afterCreation = Date()

        let tasks = service.getAllTasks()
        XCTAssertEqual(tasks.count, 2)
        let first = try XCTUnwrap(tasks.first)
        let second = try XCTUnwrap(tasks.last)

        XCTAssertEqual(first.name, "Задача А")
        XCTAssertEqual(first.description, "Описание А")
        XCTAssertEqual(service.getPriorityTasks(priority: .high).map(\.id), [first.id])
        XCTAssertFalse(first.isCompleted)
        XCTAssertNotEqual(first.id, second.id)
        XCTAssertTrue(tasks.allSatisfy { $0.date >= beforeCreation && $0.date <= afterCreation })
    }

    func testUpdateStatusByID() throws {
        let service = ServiceTask(taskList: [])
        service.createTask(name: "Задача", description: "", isCompleted: false, priority: .medium)
        let id = try XCTUnwrap(service.getAllTasks().first?.id)

        try service.updateStatus(id: id, isCompleted: true)
        XCTAssertEqual(service.getAllTasks().first?.isCompleted, true)

        XCTAssertThrowsError(try service.updateStatus(id: UUID(), isCompleted: true)) { error in
            guard case StorageError.updateFailed = error else {
                return XCTFail("Ожидалась ошибка updateFailed, получена \(error)")
            }
        }
    }

    func testDeleteTaskByID() throws {
        let service = ServiceTask(taskList: [])
        service.createTask(name: "Задача", description: "", isCompleted: false, priority: .medium)
        let id = try XCTUnwrap(service.getAllTasks().first?.id)

        XCTAssertThrowsError(try service.deleteTask(id: UUID())) { error in
            guard case StorageError.deleteFailed = error else {
                return XCTFail("Ожидалась ошибка deleteFailed, получена \(error)")
            }
        }

        XCTAssertEqual(service.getAllTasks().count, 1)
        try service.deleteTask(id: id)
        XCTAssertTrue(service.getAllTasks().isEmpty)
    }

    func testCompletedAndPriorityFilters() {
        let service = ServiceTask(taskList: [])
        service.createTask(name: "А", description: "", isCompleted: true, priority: .high)
        service.createTask(name: "Б", description: "", isCompleted: false, priority: .high)
        service.createTask(name: "В", description: "", isCompleted: true, priority: .low)

        XCTAssertEqual(service.getCompletedTasks().map(\.name), ["А", "В"])
        XCTAssertEqual(service.getPriorityTasks(priority: .high).map(\.name), ["А", "Б"])
        XCTAssertTrue(service.getPriorityTasks(priority: .medium).isEmpty)
    }

    func testSortByDateDoesNotChangeStoredOrder() {
        let older = ListTaskModel(name: "Старая", id: UUID(), description: "", date: Date(timeIntervalSince1970: 100), priority: .low, isCompleted: false)
        let newer = ListTaskModel(name: "Новая", id: UUID(), description: "", date: Date(timeIntervalSince1970: 200), priority: .high, isCompleted: false)
        let service = ServiceTask(taskList: [older, newer])

        XCTAssertEqual(service.getSortDateTasks().map(\.id), [newer.id, older.id])
        XCTAssertEqual(service.getAllTasks().map(\.id), [older.id, newer.id])
    }
}
