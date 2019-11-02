import UIKit
import SnapKit

class AddressAutocompleteCell: UITableViewCell {
    static let reuseIdentifier = "AddressAutocompleteCell"

    var isAnimating: Bool { get { return self.spinner.isAnimating } }

    let streetAddressLabel = PortalLabel(size: 22.0)
    let regionLabel = PortalLabel(size: 12.0)
    let accessoryWrapper = UIView()
    let spinner = UIActivityIndicatorView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        spinner.color = Colors.greyDark.color
        accessoryWrapper.safelyAddSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let views = [
            "street"    : streetAddressLabel,
            "accessory" : accessoryWrapper,
            "region"    : regionLabel
        ]

        let layouts = [
            "H:|[accessory(==64)][street]-(14)-|",
            "H:[accessory][region]-(14)-|",
            "V:|[accessory]|",
            "V:|-(14)-[street]-(2)-[region]-(14)-|"
        ]

        contentView.addNamedSubviews(views, withLayoutStrings: layouts)
        accessoryWrapper.setContentHuggingPriority(.defaultLow, for: .vertical)
        for v in [streetAddressLabel, regionLabel] {
            v.setContentHuggingPriority(.required, for: .vertical)
            v.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }

    func resetContent() {
        streetAddressLabel.text = ""
        regionLabel.text        = ""
    }

    func configure(_ place: SmartyStreetsAutocompleteSuggestion) {
        resetContent()
        let country = "United States"
        var regionText = ""
        streetAddressLabel.text = place.streetLine
        if let city = place.city {
            regionText = "\(city), "
        }
        if let state = place.state {
            regionText += "\(state), "
        }
        regionLabel.text = "\(regionText)\(country)"
    }

    func startAnimating() {
        self.spinner.startAnimating()
    }

    func stopAnimating() {
        self.spinner.stopAnimating()
    }
}
