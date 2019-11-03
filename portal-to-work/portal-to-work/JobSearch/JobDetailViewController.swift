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
        realView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        realView.lessButton.addTarget(self, action: #selector(lessButtonTapped), for: .touchUpInside)
    }
    
    @objc private func moreButtonTapped() {
        realView.descriptionLabel.lineBreakMode = .byWordWrapping
        realView.descriptionLabel.numberOfLines(0)
        realView.moreButton.isHidden = true
        realView.lessButton.isHidden = false
        realView.layoutIfNeeded()
    }
    
    @objc private func lessButtonTapped() {
        realView.descriptionLabel.lineBreakMode = .byTruncatingTail
        realView.descriptionLabel.numberOfLines(1)
        realView.moreButton.isHidden = false
        realView.lessButton.isHidden = true
        realView.layoutIfNeeded()
    }
    
    private func configureView() {
        realView.jobTitle.text = job.title
        realView.employer.text = job.employer.name
        realView.descriptionLabel.setHTMLFromString(htmlText: job.tempDescription())
    }
}
