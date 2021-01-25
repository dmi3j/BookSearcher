//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

public protocol AllDependencies: HasBookService {}

public protocol HasBookService: class {
    var bookService: BookService { get set }
}

final class AppDependencies: AllDependencies {

    lazy var bookService: BookService = {
        GoogleBookService()
    }()
}
