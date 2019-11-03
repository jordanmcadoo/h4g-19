import UIKit

class MainTabBarController: UITabBarController {
    private let jobCoordinator = JobCoordinator()
    private let eventCoordinator = EventCoordinator()
    private let favoritesCoordinator = FavoritesCoordinator()
    
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
        favoritesCoordinator.start()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [jobCoordinator.rootViewController,
                           eventCoordinator.rootViewController,
                           favoritesCoordinator.rootViewController]
    }
    
    private func setupTabBar() {
        jobCoordinator.rootViewController.tabBarItem.title = nil
        let myTabBarItem1 = tabBar.items?[0]
        let myTabBarItem2 = tabBar.items?[1]
        let myTabBarItem3 = tabBar.items?[2]
        myTabBarItem1?.title = ""
        myTabBarItem2?.title = ""
        myTabBarItem3?.title = ""
        if #available(iOS 13.0, *) {
            myTabBarItem1?.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem2?.image = UIImage(systemName: "calendar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem3?.image = UIImage(named: "hearticon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem3?.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 5, right: 0)
        } else {
            // Fallback on earlier versions
            myTabBarItem1?.title = "Jobs"
            myTabBarItem2?.title = "Events"
            myTabBarItem3?.title = "Favorites"
        }

    }
}
