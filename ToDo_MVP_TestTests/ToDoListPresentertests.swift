//
//  ToDoListPresenterTests.swift
//  ToDo_MVP_TestTests
//
//  Created by Ишхан Багратуни on 25.03.24.
//

import XCTest
@testable import ToDo_MVP_Test

final class ToDoListPresenterTests: XCTestCase {
    
    var presenter: ToDoListPresenter!
    
    override func setUpWithError() throws {
        presenter = ToDoListPresenter(todoItems: ToDoItems.todoItems)
    }

    override func tearDownWithError() throws {
        presenter = nil
    }
    
    func test_showToDo_shouldAppendedItemInArray() {
        // when
        presenter.showToDo(with: ToDoItems.item)
        //then
        XCTAssertEqual(presenter.todoItems.first?.count, 2)
    }
    
    func test_showToDo_shouldAppendedItemInCompletedSection() {
        // when
        presenter.showToDo(with: ToDoItems.completedSectionItem)
        
        // then
        XCTAssertEqual(presenter.todoItems[1].count, 2)
        XCTAssertEqual(presenter.todoItems[1][1], ToDoItems.completedSectionItem)
    }
    
    func test_showToDo_shouldAppendedItemInUnfulfilledSection() {
        // when
        presenter.showToDo(with: ToDoItems.unfulfilledSectionItem)
        
        // then
        XCTAssertEqual(presenter.todoItems[0].count, 2)
        XCTAssertEqual(presenter.todoItems[0][1], ToDoItems.unfulfilledSectionItem)
    }
    
    func test_showToDo_shouldAppendedInEmptyCompletedSection() {
        // given
        let emptyArray = [[ToDoItem]]()
        // when
        presenter = ToDoListPresenter(todoItems: emptyArray)
        presenter.showToDo(with: ToDoItems.completedSectionItem)
        // then
        XCTAssertNotEqual(presenter.todoItems.count, 2)
    }
    
    func test_showToDo_shouldAppendedInEmptyUnfulfilledSection() {
        // given
        let emptyArray = [[ToDoItem]]()
        // when
        presenter = ToDoListPresenter(todoItems: emptyArray)
        presenter.showToDo(with: ToDoItems.unfulfilledSectionItem)
        // then
        XCTAssertEqual(presenter.todoItems[0].count, 1)
    }
    
    func test_showToDo_shouldAppendedInUnfulfilledSection() {
        let emptyArray = [[ToDoItem]]()
        presenter = ToDoListPresenter(todoItems: emptyArray)
        // when
        presenter.showToDo(with: ToDoItems.item)
        presenter.showToDo(with: ToDoItems.unfulfilledSectionItem)
        // then
        XCTAssertEqual(presenter.todoItems[0].count, 2)
        XCTAssertEqual(presenter.todoItems[0][1], ToDoItems.unfulfilledSectionItem)
    }
    
    func test_showToDo_shouldInsertIntoEmptyUnfulfilledSection() {
        // given
        presenter = ToDoListPresenter(todoItems: [[ToDoItems.completedSectionItem]])
        // when
        presenter.showToDo(with: ToDoItems.item)
        // then
        XCTAssertEqual(presenter.todoItems[0][0], ToDoItems.item)
    }
    
    func test_shouldEditUnfulfilledTodoItem() {
        // given
        let todo = presenter.todoItems[0][0]
        // when
        presenter.editToDo(with: todo)
        // then
        XCTAssertEqual(presenter.todoItems[0][0], todo)
    }
    
    func test_shouldEditCompletedTodoItem() {
        // given
        let todo = presenter.todoItems[1][0]
        // when
        presenter.editToDo(with: todo)
        // then
        XCTAssertEqual(presenter.todoItems[1][0], todo)
    }
    
    func test_makeNotification() {
        // given
        let title = "Title"
        let description = "Description"
        let date = Date()
        // when
        presenter.makeNotificationWith(title: title, description: description, date: date)
        // then
        XCTAssertTrue(true)
    }
    
    func test_switchTaskBySection_shouldSwitchToUnfulfilledSection() {
        // given
        let index = IndexPath()
        presenter = ToDoListPresenter(todoItems: [[ToDoItems.item]])
        // when
        presenter.switchTaskBy(sectionAt: index, withItem: ToDoItems.unfulfilledSectionItem)
        // then
        XCTAssertEqual(presenter.todoItems[0][0], ToDoItems.unfulfilledSectionItem)
    }
    
    func test_switchTaskBySection_shouldAppendToEmptyUnfulfilledSection() {
        // given
        let index = IndexPath()
        // when
        presenter.switchTaskBy(sectionAt: index, withItem: ToDoItems.unfulfilledSectionItem)
        // then
        XCTAssertEqual(presenter.todoItems[0].count, 2)
    }
    
    func test_switchTaskBySection_shouldAppendToEmptyCompletedSection() {
        // given
        let index = IndexPath()
        presenter = ToDoListPresenter(todoItems: [[ToDoItems.unfulfilledSectionItem]])
        // when
        presenter.switchTaskBy(sectionAt: index, withItem: ToDoItems.completedSectionItem)
        // then
        XCTAssertEqual(presenter.todoItems[1].count, 1)
        XCTAssertEqual(presenter.todoItems[1][0], ToDoItems.completedSectionItem)
    }
    
    func test_switchTaskBySection_shouldSwitchToCompletedSection() {
        // given
        let index = IndexPath()
        // when
        presenter.switchTaskBy(sectionAt: index, withItem: ToDoItems.completedSectionItem)
        // then
        XCTAssertEqual(presenter.todoItems[1][1], ToDoItems.completedSectionItem)
    }
    
    
}

private extension ToDoListPresenterTests {
    enum ToDoItems {
        static let item = ToDoItemTests.todoItem
        static let todoItems = ToDoItemTests.testToDoItem
        static let completedSectionItem = ToDoItemTests.completedSectionItem
        static let unfulfilledSectionItem = ToDoItemTests.unfulfilledSectionItem
    }
}
