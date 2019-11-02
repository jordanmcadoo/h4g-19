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
        jobCoordinator.rootViewController.tabBarItem.title = nil
        let myTabBarItem1 = tabBar.items?[0]
        let myTabBarItem2 = tabBar.items?[1]
        myTabBarItem1?.title = ""
        myTabBarItem2?.title = ""
        if #available(iOS 13.0, *) {
            myTabBarItem1?.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem2?.image = UIImage(systemName: "calendar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        } else {
            // Fallback on earlier versions
        }
    }
}
