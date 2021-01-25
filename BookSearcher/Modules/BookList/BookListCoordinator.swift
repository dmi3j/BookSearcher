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
            //TODO: add viewModel
            (self.rootViewController as? UINavigationController)?.pushViewController(viewController, animated: false)
        }
    }
}
