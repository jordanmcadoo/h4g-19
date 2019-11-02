import SnapKit

class JobSearchView: BuildableView {
//    let addressTextField = PortalTextField(title: "YOUR ADDRESS")
    let searchBarContainerView = UIView()
    let travelTimeLabel = PortalLabel(size: 22, allCaps: true, text: "MAX TRAVEL TIME (MINS)")
    let travelTimeControl: UISegmentedControl =  {
        let control = UISegmentedControl(items: ["10", "15", "30", "45", "60+"])
        control.selectedSegmentTintColor = Branding.primaryColor()
        return control
    }()
    let searchButton = PortalButton(title: "SEARCH")
    
    override var hierarchy: ViewHierarchy {
        return .views([searchBarContainerView,
                       travelTimeLabel,
                       travelTimeControl,
                       searchButton])
    }
    
    override func installConstraints() {
        searchBarContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        travelTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBarContainerView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        travelTimeControl.snp.makeConstraints { make in
            make.top.equalTo(travelTimeLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(travelTimeControl.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
