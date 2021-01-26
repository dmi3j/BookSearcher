//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

protocol BookListVMVD: ViewModelViewDelegate {
    func showSearchProgress()
    func reloadData()
}

protocol BookListVMCD: ViewModelCoordinatorDelegate {

}

protocol BookListViewModel: ViewModel {
    var viewDelegate: BookListVMVD? { get set }
    var coordinatorDelegate: BookListVMCD? { get set}

    var bookCount: Int { get }
    func book(at index: Int) -> Book?
    func selectBook(at index: Int)
    func searchBook(using query: String)
}

final class GoogleBookListViewModel: BookListViewModel {
    typealias Dependencies = HasBookService

    weak var viewDelegate: BookListVMVD?
    weak var coordinatorDelegate: BookListVMCD?

    private let dependencies: Dependencies
    private var books: [Book] = []

    init(with dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    var bookCount: Int { books.count }

    func book(at index: Int) -> Book? {
        books.indices.contains(index) ? books[index] : nil
    }

    func selectBook(at index: Int) {
        guard books.indices.contains(index) else { return }

    }

    func searchBook(using query: String) {
        viewDelegate?.showSearchProgress()
        dependencies.bookService.findBooks(query: query) { (result) in
            switch result {
            case .success(let foundBooks):
                self.books = foundBooks

            case .failure(let error):
                debugPrint(error)
                //TODO: add proper error display
                self.books = []
            }

            self.viewDelegate?.reloadData()
        }
    }
}
