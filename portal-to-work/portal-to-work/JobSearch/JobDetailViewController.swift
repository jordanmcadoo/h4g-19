import UIKit

class JobDetailViewController: UIViewController {
    private let realView = JobDetailView()
    private let job: Job
    
    init(job: Job) {
        self.job = job
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = realView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "JOB DETAILS"
        configureView()
        
    }
    
    private func configureView() {
        realView.jobTitle.text = job.title
        realView.employer.text = job.employer.name
        realView.descriptionLabel.setHTMLFromString(htmlText: job.tempDescription())
    }
}
