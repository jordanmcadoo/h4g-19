import SnapKit

class JobDetailView: BuildableView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let jobTitle = PortalLabel()
    let employer = PortalLabel()
    
    override var hierarchy: ViewHierarchy {
        return .view(scrollView, [
            .view(contentView, [
                .views([jobTitle,
                        employer
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
            make.leading.equalToSuperview().offset(20)
        }

        employer.snp.makeConstraints { make in
            make.leading.equalTo(jobTitle.snp.leading)
            make.top.equalTo(jobTitle.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
