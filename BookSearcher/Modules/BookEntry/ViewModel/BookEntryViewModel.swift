//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

protocol BookEntryVMVD: ViewModelViewDelegate {
    func reloadData()
}

protocol BookEntryVMCD: ViewModelCoordinatorDelegate {
    func bookEntryViewModelDidClose(_ viewModel: BookEntryViewModel)
}

protocol BookEntryViewModel: ViewModel {
    var viewDelegate: BookEntryVMVD? { get set }
    var coordinatorDelegate: BookEntryVMCD? { get set}

    var book: Book { get }
    func close()
}

final class GoogleBookEntryViewModel: BookEntryViewModel {
    typealias Dependencies = HasBookService

    weak var viewDelegate: BookEntryVMVD?
    weak var coordinatorDelegate: BookEntryVMCD?

    var book: Book

    init(with book: Book) {
        self.book = book
    }

    func close() {
        coordinatorDelegate?.bookEntryViewModelDidClose(self)
    }
}
