import SnapKit

class JobDetailView: BuildableView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let jobTitle = PortalLabel(desiredFont: UIFont.boldSystemFont(ofSize: 25), size: 25)
    let employer = PortalLabel(size: 20)
    let descriptionLabel = PortalLabel().withWrappedText()
    
    override var hierarchy: ViewHierarchy {
        return .view(scrollView, [
            .view(contentView, [
                .views([jobTitle,
                        employer,
                        descriptionLabel
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
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
