import UIKit
import CoreLocation

class JobCoordinator: RootedCoordinator {
    private let navController: UINavigationController
    private let jobSearchVC = JobSearchViewController()
    private let jobsService = JobsService()
    
    init() {
        self.navController = UINavigationController(rootViewController: jobSearchVC)
        super.init(rootViewController: navController)
        
        jobSearchVC.delegate = self
        jobsService.getData { success in
            
        }
    }
}

extension JobCoordinator: JobSearchViewControllerDelegate {
    func jobSearchViewController(_: JobSearchViewController, didReceiveLocation location: CLLocation) {
        let jobResultsVC = JobResultsViewController(location: location, jobsService: jobsService)
        jobResultsVC.delegate = self
        navController.pushViewController(jobResultsVC, animated: true)
    }
}

extension JobCoordinator: JobResultsViewControllerDelegate {
    func jobResultsViewController(_: JobResultsViewController, didSelectJob job: Job) {
        let jobDetailVC = JobDetailViewController(job: job)
        navController.pushViewController(jobDetailVC, animated: true)
    }
}
