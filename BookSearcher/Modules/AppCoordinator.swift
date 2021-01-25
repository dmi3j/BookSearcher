//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

final class AppCoordinator: Coordinator {
    let window: UIWindow
    var rootViewController: UIViewController?
    var childCoordinators: [Coordinator] = []

    var dependencies: AllDependencies = AppDependencies()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.rootViewController = UINavigationController()
            self.window.rootViewController = self.rootViewController
            self.window.makeKeyAndVisible()

            if let navigationController = self.rootViewController as? UINavigationController {
                let coordinator = BookListCoordinator(with: self.dependencies,
                                                  navigationController: navigationController)
                self.push(coordinator)
                coordinator.start()
            }
        }
    }
}
