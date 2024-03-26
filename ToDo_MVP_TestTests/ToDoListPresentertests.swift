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
    
    func test_showToDo_shouldInsertionAtTheBeginningOfAnArray() {
        // given
        presenter = ToDoListPresenter(todoItems: [[ToDoItems.completedSectionItem]])
        // when
        presenter.showToDo(with: ToDoItems.item)
        // then
        XCTAssertEqual(presenter.todoItems[0][0], ToDoItems.item)
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
