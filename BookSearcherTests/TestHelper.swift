//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

class TestHelper {

    class func getDataContent(from file: String) -> Data? {
        guard let fileURL = Bundle(identifier: "me.dmi3j.BookSearcherTests")?.path(forResource: file, ofType: "json") else {
            return nil
        }
        guard let jsonString = try? String(contentsOfFile: fileURL, encoding: .utf8) else {
            return nil
        }
        if let jsonData = jsonString.data(using: .utf8) {
            return jsonData
        }
        return nil
    }
}
