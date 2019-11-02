import UIKit

class JobCoordinator: RootedCoordinator {
    private let jobSearchVC = JobSearchViewController()
    
    init() {
        super.init(rootViewController: jobSearchVC)
    }
}
