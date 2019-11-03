import UIKit

class EventCoordinator: RootedCoordinator {
    private let navController: UINavigationController
    private let eventsVC = EventsViewController()
    private let eventsService = EventsService()
    private let eventsPromise: EventsPromise
    
    init() {
        self.navController = UINavigationController(rootViewController: eventsVC)
        self.eventsPromise = eventsService.events()
        super.init(rootViewController: navController)
        
        eventsPromise.done { events in
            self.eventsVC.events = events
        }.catch { error in
            // todo error
        }
    }
}
