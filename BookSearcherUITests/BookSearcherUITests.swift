//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import XCTest

class BookSearcherUITests: XCTestCase {

    func waitForElementToAppear(element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testSampleSearch() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.searchFields["bookSearchField"]
        guard searchField.exists else { XCTFail("Search field is missing"); return }

        searchField.tap()
        searchField.typeText("iOS")
        app.keyboards.buttons["Search"].tap()

        let cell = app.cells["bookCell"]
        waitForElementToAppear(element: cell)
        if cell.exists == false { XCTFail("Result cell is missing"); return }
    }
}
