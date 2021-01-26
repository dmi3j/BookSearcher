//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

//MARK: - Coordinator

protocol Coordinator: class {
    var rootViewController: UIViewController? { get }
    var childCoordinators: [Coordinator] { get set }

    func start()
    func push(_ coordinator: Coordinator)
    func pop(_ coordinator: Coordinator)
}

extension Coordinator {

    func push(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func pop(_ coordinator: Coordinator) {
        var coordinatorIndex = -1
        for (index, value) in childCoordinators.enumerated() where value === coordinator {
            coordinatorIndex = index
        }

        if coordinatorIndex > -1 {
            childCoordinators.remove(at: coordinatorIndex)
        }
    }
}

//MARK: - ViewModel

public protocol ViewModel: class {

}

public protocol ViewModelViewDelegate: class {

}

public protocol ViewModelCoordinatorDelegate: class {

}

//MARK: - View

protocol Storyboardable: class {
    static var defaultStoryboardIdentifier: String { get }
}

extension Storyboardable where Self: UIViewController {

    static var defaultStoryboardIdentifier: String {
        String(describing: self)
    }

    static func load(from storyboardName: String, with identifier: String? = nil) -> Self? {
        let identifier: String = identifier ?? defaultStoryboardIdentifier
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)

        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            assertionFailure("Failed to instantiate viewcontroller with identifier: \(identifier)")
            return nil
        }

        return viewController
    }
}

extension UIViewController: Storyboardable {}
