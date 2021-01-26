//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import XCTest
@testable import BookSearcher

class BookSearcherTests: XCTestCase {

    func testAllBookFieldsParsing() {
        let fileName = "book_all_fields"
        guard let jsonData = TestHelper.getDataContent(from: fileName) else {
            XCTFail("Failed to load test data from \(fileName).json")
            return
        }

        let book: GoogleBook
        do {
            book = try JSONDecoder().decode(GoogleBook.self, from: jsonData)
        } catch {
            XCTFail("Failed to decode Book")
            return
        }

        XCTAssertEqual(book.title, "Lorem ipsum dolor sit amet")
        XCTAssertEqual(book.description, "Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        XCTAssertEqual(book.authors[0], "John Doe")
        XCTAssertEqual(book.authors[1], "Jane Doe")
        XCTAssertEqual(book.smallThumbnail, "lorem&lorem&lorem")
        XCTAssertEqual(book.bigThumbnail, "lorem_ipsum&lorem_ipsum&lorem_ipsum")
    }

    func testMinBookFieldsParsing() {
        let fileName = "book_min_fields"
        guard let jsonData = TestHelper.getDataContent(from: fileName) else {
            XCTFail("Failed to load test data from \(fileName).json")
            return
        }

        let book: GoogleBook
        do {
            book = try JSONDecoder().decode(GoogleBook.self, from: jsonData)
        } catch {
            XCTFail("Failed to decode Book")
            return
        }

        XCTAssertEqual(book.title, "Lorem ipsum dolor sit amet")
        XCTAssertEqual(book.description, "n/a")
        XCTAssertEqual(book.authors.count, 0)
        XCTAssertEqual(book.smallThumbnail, "")
        XCTAssertEqual(book.bigThumbnail, "")
    }
}
