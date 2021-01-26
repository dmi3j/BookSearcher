//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

protocol BookEntryCD: CoordinatorDelegate {
    func bookEntryCoordinatorDidFinish(coordinator: BookEntryCoordinator)
}

final class BookEntryCoordinator: Coordinator {

    var rootViewController: UIViewController?
    var childCoordinators: [Coordinator] = []

    weak var delegate: BookEntryCD?

    private let book: Book

    init(with book: Book, rootViewController: UIViewController) {
        self.book = book
        self.rootViewController = rootViewController
    }

    func start() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            guard let viewController = BookEntryViewController.load(from: "BookEntry") else { return }
            let viewModel = GoogleBookEntryViewModel(with: self.book)
            viewModel.coordinatorDelegate = self
            viewController.viewModel = viewModel
            let wrapper = UINavigationController(rootViewController: viewController)
            if #available(iOS 13.0, *) {
                wrapper.isModalInPresentation = true
            }
            self.rootViewController?.present(wrapper, animated: true, completion: nil)
        }
    }
}


// MARK: - BookEntryVMCD
extension BookEntryCoordinator: BookEntryVMCD {

    func bookEntryViewModelDidClose(_ viewModel: BookEntryViewModel) {
        self.rootViewController?.dismiss(animated: true, completion: {
            self.delegate?.bookEntryCoordinatorDidFinish(coordinator: self)
        })
    }
}
