import SnapKit

class JobDetailView: BuildableView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let jobTitle = PortalLabel(size: 25)
    let employer = PortalLabel(desiredFont: UIFont.boldSystemFont(ofSize: 1), size: 18, color: Branding.secondaryColor())
    let linkToApply = PortalButton(title: "Apply")
    let descriptionLabel = PortalLabel(size: 18).withLines(1)//.withWrappedText()
    let moreButton = PortalSecondaryButton(title: "More")
    let lessButton = PortalSecondaryButton(title: "Less").hidden(true)
    
    override var hierarchy: ViewHierarchy {
        return .view(scrollView, [
            .view(contentView, [
                .views([jobTitle,
                        employer,
                        linkToApply,
                        descriptionLabel,
                        moreButton,
                        lessButton
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
            make.trailing.equalTo(linkToApply.snp.leading).priority(.medium)
        }
        
        employer.snp.makeConstraints { make in
            make.top.equalTo(jobTitle.snp.bottom).offset(5)
            make.leading.equalTo(jobTitle.snp.leading)
            make.trailing.equalTo(linkToApply.snp.leading).priority(.medium)
        }
        
        linkToApply.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.width.equalTo(64).priority(.high)
            make.trailing.equalToSuperview().offset(-10)
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
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        lessButton.snp.makeConstraints { make in
            make.edges.equalTo(moreButton.snp.edges)
        }
    }
}
