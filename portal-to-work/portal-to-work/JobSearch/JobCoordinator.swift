import UIKit
import CoreLocation

class JobCoordinator: RootedCoordinator {
    private let navController: UINavigationController
    private let jobSearchVC = JobSearchViewController()
    
    init() {
        self.navController = UINavigationController(rootViewController: jobSearchVC)
        super.init(rootViewController: navController)
        
        jobSearchVC.delegate = self
    }
}

extension JobCoordinator: JobSearchViewControllerDelegate {
    func jobSearchViewController(_: JobSearchViewController, didReceiveLocation location: CLLocation) {
        print("in coordinator")
        let jobResultsVC = JobResultsViewController(location: location)
        navController.pushViewController(jobResultsVC, animated: true)
    }
}
