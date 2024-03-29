import UIKit
import CoreLocation

class JobResultsCell: UITableViewCell {
    static let reuseIdentifier = "JobResultsCell"
    let jobView = UIView()
    private let jobTitle = PortalLabel(desiredFont: UIFont.boldSystemFont(ofSize: 18), size: 18)
    private let employer = PortalLabel()
    private let distance = PortalLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        jobTitle.setContentHuggingPriority(.required, for: .vertical)
        employer.setContentHuggingPriority(.required, for: .vertical)
        distance.setContentHuggingPriority(.required, for: .vertical)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setUpViews()
        initializeConstraints()
    }

    private func setUpViews() {
        contentView.safelyAddSubview(jobView)
        jobView.safelyAddSubview(jobTitle)
        jobView.safelyAddSubview(employer)
        jobView.safelyAddSubview(distance)
    }

    private func initializeConstraints() {
        jobView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        jobTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        distance.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().inset(20)
        }
        
        employer.snp.makeConstraints { make in
            make.leading.equalTo(jobTitle.snp.leading)
            make.top.equalTo(jobTitle.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    func setupWithJob(_ job: Job, location: CLLocation) {
        jobTitle.text = job.title
        employer.text = job.employer.name
        
        guard let distanceInMiles = job.distanceInMiles(fromLocation: location) else {
            return
        }
        distance.text = "\(round(distanceInMiles * 100) / 100) mi"
    }
}
