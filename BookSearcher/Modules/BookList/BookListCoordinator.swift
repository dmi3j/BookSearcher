//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

final class BookListCoordinator: Coordinator {
    typealias Dependencies = HasBookService

    var rootViewController: UIViewController?
    var childCoordinators: [Coordinator] = []

    private let dependencies: HasBookService

    init(with dependencies: Dependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.rootViewController = navigationController
    }

    func start() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            guard let viewController = BookListViewController.load(from: "BookList") else { return }
            let viewModel = GoogleBookListViewModel(with: self.dependencies)
            viewModel.coordinatorDelegate = self
            viewController.viewModel = viewModel
            (self.rootViewController as? UINavigationController)?.pushViewController(viewController, animated: false)
        }
    }
}

// MARK: - BookListVMCD
extension BookListCoordinator: BookListVMCD {

    func bookListViewModel(_ viewModel: BookListViewModel, open book: Book) {
        guard let navigationController = rootViewController else { return }
        let coordinator = BookEntryCoordinator(with: book, rootViewController: navigationController)
        push(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
}

// MARK: - BookListVMCD
extension BookListCoordinator: BookEntryCD {

    func bookEntryCoordinatorDidFinish(coordinator: BookEntryCoordinator) {
        pop(coordinator)
    }

}
