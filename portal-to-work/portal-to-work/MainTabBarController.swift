import UIKit

class MainTabBarController: UITabBarController {
    private let jobCoordinator = JobCoordinator()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupTabControllers()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabControllers() {
        jobCoordinator.start()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [jobCoordinator.rootViewController]
    }
}
