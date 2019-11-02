import UIKit

class MainTabBarController: UITabBarController {
    private let jobCoordinator = JobCoordinator()
    private let eventCoordinator = EventCoordinator()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupTabControllers()
        setupTabBar()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabControllers() {
        jobCoordinator.start()
        eventCoordinator.start()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [jobCoordinator.rootViewController,
                           eventCoordinator.rootViewController]
    }
    
    private func setupTabBar() {
        let myTabBarItem1 = tabBar.items?[0]
        myTabBarItem1?.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1?.title = ""
        
        let myTabBarItem2 = tabBar.items?[1]
        myTabBarItem2?.image = UIImage(systemName: "calendar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2?.title = ""
    }
}
