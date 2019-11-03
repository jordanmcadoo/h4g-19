import UIKit
import CoreLocation

class JobCoordinator: RootedCoordinator {
    private let navController: UINavigationController
    private let jobSearchVC = JobSearchViewController()
    private let jobsService = JobsService()
    private let jobsPromise: JobsPromise
    
    init() {
        self.navController = UINavigationController(rootViewController: jobSearchVC)
        self.jobsPromise = jobsService.jobs()
        super.init(rootViewController: navController)
        
        jobSearchVC.delegate = self
    }
}

extension JobCoordinator: JobSearchViewControllerDelegate {
    func jobSearchViewController(_ jobSearchVC: JobSearchViewController, didReceiveLocation location: CLLocation) {
        jobsPromise.ensure {
            jobSearchVC.stopSpinnner()
        }.done { jobs in
            let jobResultsVC = JobResultsViewController(location: location, jobs: jobs)
            jobResultsVC.delegate = self
            self.navController.pushViewController(jobResultsVC, animated: true)
        }.catch { error in
            // todo - show error
        }
    }
}

extension JobCoordinator: JobResultsViewControllerDelegate {
    func jobResultsViewController(_: JobResultsViewController, didSelectJob job: Job) {
        let jobDetailVC = JobDetailViewController(job: job)
        navController.pushViewController(jobDetailVC, animated: true)
    }
}
