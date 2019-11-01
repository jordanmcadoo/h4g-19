import SnapKit

class JobSearchView: BuildableView {
    let addressLabel = PortalTextField(title: "YOUR ADDRESS")
    
    override var hierarchy: ViewHierarchy {
        return .views([addressLabel])
    }
    
    override func installConstraints() {
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}

