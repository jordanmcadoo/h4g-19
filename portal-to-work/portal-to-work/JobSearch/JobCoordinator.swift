import UIKit
import CoreLocation

class JobCoordinator: RootedCoordinator {
    private let jobSearchVC = JobSearchViewController()
    
    init() {
        super.init(rootViewController: jobSearchVC)
        
        jobSearchVC.delegate = self
    }
}

extension JobCoordinator: JobSearchViewControllerDelegate {
    func jobSearchViewController(_: JobSearchViewController, didReceiveLocation: CLLocation) {
        print("in coordinator")
    }
}
