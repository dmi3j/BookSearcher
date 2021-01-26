//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

public protocol AllDependencies: HasBookService, HasNetwork {}

public protocol HasBookService: class {
    var bookService: BookService { get set }
}

public protocol HasNetwork: class {
    var network: Network { get set }
}

final class AppDependencies: AllDependencies {

    lazy var bookService: BookService = {
        GoogleBookService(network: network)
    }()

    lazy var network: Network = {
        NetworkService()
    }()
}
