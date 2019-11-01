import UIKit

class MainTabBarController: UITabBarController {
    let jobSearchVC: JobSearchViewController
    
    init() {
        self.jobSearchVC = JobSearchViewController()
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [jobSearchVC]
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
    }
}
