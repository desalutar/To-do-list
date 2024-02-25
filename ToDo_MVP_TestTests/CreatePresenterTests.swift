//
//  CreatePresenterTests.swift
//  ToDo_MVP_TestTests
//
//  Created by Ишхан Багратуни on 04.02.24.
//

import XCTest
@testable import ToDo_MVP_Test

final class CreatePresenterTests: XCTestCase {

    var presenter: CreateToDoPresenter!
    var viewMock: CreateViewControllerMock!
    
    
    override func setUpWithError() throws {
        presenter = CreateToDoPresenter()
        viewMock = CreateViewControllerMock()
        presenter.view = viewMock
    }

    override func tearDownWithError() throws {
        presenter = nil
        viewMock = nil
    }

    func test_createToDo_shouldCreateNewToDo() {
        // given
        let data = ToDoItemData(title: "foo", description: "baz", isCompleted: false, date: nil)
        
        // when
        presenter.createToDo(with: data)
        viewMock.didCreateToDoArgument = ToDoItem(title: "foo", description: "baz", date: nil)
        
        // then
        
        XCTAssertEqual(viewMock.didCreateToDoWasTapped, 1)
        
    }
}
