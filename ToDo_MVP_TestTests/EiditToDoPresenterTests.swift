//  EditToDoPresenterTests.swift
//  ToDo_MVP_TestTests
//
//  Created by Ишхан Багратуни on 26.02.24.
//

import XCTest
@testable import ToDo_MVP_Test

final class EditToDoPresenterTests: XCTestCase {

    var presenter: EditToDoPresenter!
    var viewMock: EditToDoViewMock!
    
    override func setUpWithError() throws {
        let testData = TestData.todoItem
        presenter = EditToDoPresenter(todoItem: testData)
        viewMock = EditToDoViewMock()
        presenter.view = viewMock
    }

    override func tearDownWithError() throws {
        presenter = nil
        viewMock = nil
    }
    
    func test_editToDo_shouldBeEdited() {
        // given
        let todoItemData = TestData.todoItemData
        
        // when
        presenter.didEditTodo(with: todoItemData)
        
        // then
        XCTAssertEqual(viewMock.didEditTodoWasTapped , 1)
        XCTAssertEqual(viewMock.didEditTodoArgument , TestData.todoItem)
    }
}

private extension EditToDoPresenterTests {
    enum TestData {
        static let uuid = UUID()
        static let todoItemData = ToDoItemData(
            id: uuid,
            title: "foo",
            description: "baz",
            isCompleted: false,
            imageData: nil,
            date: nil
        )
        static let todoItem = ToDoItem(
            id: uuid,
            isCompleted: false,
            title: "foo",
            description: "baz",
            picture: nil,
            date: nil
        )
    }
}
