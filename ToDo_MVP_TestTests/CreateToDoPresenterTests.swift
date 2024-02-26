//
//  CreateToDoPresenterTests.swift
//  ToDo_MVP_TestTests
//
//  Created by Ишхан Багратуни on 25.02.24.
//

import XCTest
@testable import ToDo_MVP_Test

final class CreateToDoPresenterTests: XCTestCase {

    var presenter: CreateToDoPresenter!
    var viewMock: CreateToDoViewMock!
    
    override func setUpWithError() throws {
        presenter = CreateToDoPresenter()
        viewMock = CreateToDoViewMock()
        presenter.view = viewMock
    }

    override func tearDownWithError() throws {
        presenter = nil
        viewMock = nil
    }
    
    func test_createTodo_shouldCallOnce() {
        // given
        let todoItemData = TestData.todoItemData
        
        // when
        presenter.createToDo(with: todoItemData)
        
        // then
        XCTAssertEqual(viewMock.didCreateToDoWasTapped, 1)
        XCTAssertEqual(viewMock.didCreateToDoArgument, TestData.todoItem)
    }
    
}

private extension CreateToDoPresenterTests {
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
