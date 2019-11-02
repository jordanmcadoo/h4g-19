import UIKit

class EventCoordinator: RootedCoordinator {
    private let navController: UINavigationController
    private let eventsVC = EventsViewController()
    
    init() {
        self.navController = UINavigationController(rootViewController: eventsVC)
        super.init(rootViewController: navController)
    }
}
