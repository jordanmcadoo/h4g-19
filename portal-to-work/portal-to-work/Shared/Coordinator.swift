import UIKit

protocol Coordinator: class {
    
    func addChildCoordinator(_ child: Coordinator)
    func removeChildCoordinator(_ child: Coordinator)
    func removeAllChildCoordinators()
    
    /// Implement to start flow-wide activities.
    func start()
    /// Implement to stop flow-wide activities.
    func stop()
}

class BaseCoordinator: NSObject, Coordinator {
    private(set) var childCoordinators: [Coordinator]
    
    override init() {
        childCoordinators = []
    }
    
    func addChildCoordinator(_ child: Coordinator) {
        childCoordinators.append(child)
    }
    
    func removeChildCoordinator(_ child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators = []
    }
    
    // default, no-op implementation
    func start() {
        
    }
    
    // default, no-op implementation
    func stop() {
        
    }
}

class RootedCoordinator: BaseCoordinator {
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}
