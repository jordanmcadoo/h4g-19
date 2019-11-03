import SnapKit
import MapKit

class JobDetailView: BuildableView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let jobTitle = PortalLabel(size: 25)
    let employer = PortalLabel(desiredFont: UIFont.boldSystemFont(ofSize: 1), size: 18, color: Branding.secondaryColor())
    let descriptionLabel = PortalLabel(size: 18).withLines(1)//.withWrappedText()
    let moreButton = PortalSecondaryButton(title: "More")
    let lessButton = PortalSecondaryButton(title: "Less").hidden(true)
    let mapView = MKMapView()
    let jobSpecificsView = JobSpecificsView()
    
    override var hierarchy: ViewHierarchy {
        return .view(scrollView, [
            .view(contentView, [
                .views([jobTitle,
                        employer,
                        descriptionLabel,
                        moreButton,
                        lessButton,
                        mapView,
                        jobSpecificsView
                ])
            ])
        ])
    }
    
    override func installConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        jobTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        employer.snp.makeConstraints { make in
            make.top.equalTo(jobTitle.snp.bottom).offset(5)
            make.leading.equalTo(jobTitle.snp.leading)
            make.trailing.equalTo(jobTitle.snp.trailing)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(employer.snp.bottom).offset(15)
            make.leading.equalTo(jobTitle.snp.leading)
            make.trailing.equalTo(jobTitle.snp.trailing)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        lessButton.snp.makeConstraints { make in
            make.edges.equalTo(moreButton.snp.edges)
        }
        
        mapView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.90)
            make.top.equalTo(lessButton.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        jobSpecificsView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}

class JobSpecificsView: BuildableView {
    let jobSalary = JobSpecificItem()
    let jobType = JobSpecificItem()
    let jobRequirements = JobSpecificItem()
    
    override var hierarchy: ViewHierarchy {
        return .views([jobSalary,
                       jobType,
                       jobRequirements
        ])
    }
    
    override func installConstraints() {
        jobSalary.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        jobType.snp.makeConstraints { make in
            make.top.equalTo(jobSalary.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        jobRequirements.snp.makeConstraints { make in
            make.top.equalTo(jobType.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}

class JobSpecificItem: BuildableView {
    let horizontalLine = UIView()
    let key = PortalLabel(text: "Key")
    let value = PortalLabel(text: "Value")
    
    override var hierarchy: ViewHierarchy {
        return .views([horizontalLine, key, value])
    }
    
    override func installConstraints() {
        horizontalLine.backgroundColor = Branding.primaryColor().withAlphaComponent(0.3)
        horizontalLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
        
        key.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(20)
        }
        
        value.snp.makeConstraints { make in
            make.top.bottom.equalTo(key)
            make.trailing.equalToSuperview().inset(20)
        }
        
        key.setContentCompressionResistancePriority(.required, for: .horizontal)
        key.setContentHuggingPriority(.required, for: .horizontal)
        value.setContentCompressionResistancePriority(.required, for: .horizontal)
        value.setContentHuggingPriority(.required, for: .horizontal)
    }
}
