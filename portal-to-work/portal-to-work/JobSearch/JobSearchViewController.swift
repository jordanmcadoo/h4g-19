import UIKit
import SnapKit

class JobSearchViewController: UIViewController {
    let realView = JobSearchView()
    let searchController: UISearchController
    
    init() {
        let searchResultsViewController = AddressSearchResultsViewController()
        self.searchController = UISearchController(searchResultsController: searchResultsViewController)
        super.init(nibName: nil, bundle: nil)
        
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.delegate = self
        searchResultsViewController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = realView
    }
    
    override func viewDidLoad() {
        embedSearchBar()
    }
    
    private func embedSearchBar() {
        definesPresentationContext = true

        realView.searchBarContainerView.safelyAddSubview(searchController.searchBar)
        searchController.searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(5)
        }
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    
    private func populateFields(_ address: Address) {
//        realView.addressFormView.nameField.text = address.name
//        realView.addressFormView.streetAddressField.text = address.address
//        realView.addressFormView.streetAddressFieldLineTwo.text = address.addressAdditional
//        realView.addressFormView.companyNameField.text = address.companyName
//        realView.addressFormView.cityField.text = address.city
//        realView.addressFormView.stateField.text = address.state
//        realView.addressFormView.postalCodeField.text = address.postcode
    }
}

extension JobSearchViewController: AddressSearchResultsViewControllerDelegate {
    func addressSearchResultsViewController(_ controller: AddressSearchResultsViewController, didSelectAddress shippingAddress: Address) {
        populateFields(shippingAddress)
        searchController.isActive = false
    }
}

extension JobSearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
//        realView.addressFormView.isHidden = true
        searchController.searchBar.removeMarginToSuperview()
        searchController.searchBar.pinToSuperview()
        realView.searchBarContainerView.removeMarginToSuperview()
        realView.searchBarContainerView.pinToSuperview()
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.sizeToFit()
        searchController.searchBar.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
    }

    func willDismissSearchController(_ searchController: UISearchController) {
//        realView.addressFormView.isHidden = false
        realView.searchBarContainerView.removeMarginToSuperview()
        realView.searchBarContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.removeMarginToSuperview()
        searchController.searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(5)
        }
    }
}
