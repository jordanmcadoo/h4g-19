import SnapKit

class JobSearchView: BuildableView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = PortalLabel(text: "SET LOCATION FOR JOB SEARCH").aligned(.center)
    let useCurrentAddressButton = PortalButton(title: "USE MY CURRENT LOCATION")
    let orSeparator = OrSeparator()
    let addressForm = AddressForm()
    
    override var hierarchy: ViewHierarchy {
        return .view(scrollView, [
            .view(contentView, [
                .views([titleLabel,
                        useCurrentAddressButton,
                        orSeparator,
                        addressForm
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
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        useCurrentAddressButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        orSeparator.snp.makeConstraints { make in
            make.top.equalTo(useCurrentAddressButton.snp.bottom).offset(30)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        addressForm.snp.makeConstraints { make in
            make.top.equalTo(orSeparator.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.greaterThanOrEqualToSuperview()
        }
    }
}

class AddressForm: BuildableView {
    let streetTextField = PortalTextField(title: "Street Address")
    let cityTextField = PortalTextField(title: "City")
    let stateTextField = PortalTextField(title: "State")
    let postalCodeTextField = PortalTextField(title: "Postal Code")
    let useManualAddressButton = PortalButton(title: "USE THIS ADDRESS")
    
    override var hierarchy: ViewHierarchy {
        return .views([streetTextField,
                cityTextField,
                stateTextField,
                postalCodeTextField,
                useManualAddressButton
        ])
    }
    
    override func installConstraints() {
        streetTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        cityTextField.snp.makeConstraints { make in
            make.top.equalTo(streetTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        stateTextField.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        postalCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(stateTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        useManualAddressButton.snp.makeConstraints { make in
            make.top.equalTo(postalCodeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
    }
}

class OrSeparator: BuildableView {
    let orLabel = PortalLabel(text: "OR").aligned(.center)
    
    override var hierarchy: ViewHierarchy {
        return .views([orLabel])
    }
    
    override func installConstraints() {
        orLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
