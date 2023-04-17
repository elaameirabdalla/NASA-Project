//
//  NasaSearchUITests.swift
//  NasaSearchUITests
//
//  Created by Abdalla Elaameir on 4/14/23.
//

import XCTest

final class NasaSearchUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSearchPageUI() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Asserts search bar and empty table are present
        let searchBar = app.textFields["Search here"]
        let tableView = app.tables.matching(identifier: "ResultsTable")
        var count = tableView.cells.count
        
        XCTAssertTrue(searchBar.exists)
        XCTAssertTrue(count == 0)
        
        // Taps search bar, searches term and taps return to trigger api call
        searchBar.tap()
        searchBar.typeText("Mars")
        app.keyboards.buttons["return"].tap()
        
        let cell = tableView.cells.element(matching: .cell, identifier: "searchResultCell")
        count = tableView.cells.count
        
        // Asserts tableview is populated with at least one searchResultCell
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(count > 1)
 
    }
}
