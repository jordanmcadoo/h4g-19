import UIKit

class FavoritesCoordinator: RootedCoordinator {
    private let navController: UINavigationController
    private let favoritesVC = FavoritesViewController()
    
    init() {
        self.navController = UINavigationController(rootViewController: favoritesVC)
        super.init(rootViewController: navController)
        
        favoritesVC.delegate = self
    }
}

extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    func favoritesViewController(_: FavoritesViewController, didSelectJob job: Job) {
        let jobDetailVC = JobDetailViewController(job: job)
        navController.pushViewController(jobDetailVC, animated: true)
    }
}
