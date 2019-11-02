import UIKit

struct Address {
    let address: String
    let city: String
    let state: String
    let postcode: String
}

protocol AddressSearchResultsViewControllerDelegate: class {
    func addressSearchResultsViewController(_ controller: AddressSearchResultsViewController, didSelectAddress shippingAddress: Address)
}

class AddressSearchResultsViewController: UIViewController {
    let realView = AddressSearchResultsView()
    private let smartyStreetsService = SmartyStreetsService()
    weak var delegate: AddressSearchResultsViewControllerDelegate?
    private let results: AddressSearchResults_Protocol
    
    init() {
        self.results = AddressSearchResults(smartyStreetsService: smartyStreetsService)
        super.init(nibName: nil, bundle: nil)
        results.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = realView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realView.tableView.delegate = self
        realView.tableView.dataSource = self
        
        // This is necessary so the content inset isn't an insanely large amount
        realView.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func cell(at indexPath: IndexPath) -> AddressAutocompleteCell? {
        return realView.tableView.cellForRow(at: indexPath) as? AddressAutocompleteCell
    }
    
    private func updateSearchResults(for searchText: String?) {
        realView.emptyResultsView.isHidden = true
        results.updateSearchResults(for: searchText)
    }
}

extension AddressSearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressAutocompleteCell = tableView.dequeueReusableCell(withIdentifier: AddressAutocompleteCell.reuseIdentifier) as! AddressAutocompleteCell
        if let result = results.results.at(indexPath.row) {
            cell.configure(result)
        }
        return cell
    }
}

extension AddressSearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let result = results.results.at(indexPath.row) else {
            return
        }
        
        cell(at: indexPath)?.startAnimating()
        
        _ = smartyStreetsService.detail(from: result)
            .ensure {
                self.cell(at: indexPath)?.stopAnimating()
            }.done { address in
                self.delegate?.addressSearchResultsViewController(self, didSelectAddress: address)
            }.catch { _ -> Void in
                // todo
            }
    }
}

extension AddressSearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResults(for: searchController.searchBar.text)
    }
}

extension AddressSearchResultsViewController: AddressSearchResultsDelegate {
    func addressSearchResults(_ searchResults: AddressSearchResults_Protocol, didUpdateResults results: [SmartyStreetsAutocompleteSuggestion]) {
        realView.tableView.reloadData()
        realView.emptyResultsView.isVisible = results.isEmpty
    }
}

import SnapKit

class AddressSearchResultsView: BuildableView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AddressAutocompleteCell.self, forCellReuseIdentifier: AddressAutocompleteCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68.0
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = Colors.greyDark.with(alpha: 0.6)
        return tableView
    }()
    let emptyResultsView = EmptySearchResultsView().hidden(true)
    
    override var hierarchy: ViewHierarchy {
        return .views([
            tableView,
            emptyResultsView
            ])
    }
        
    override func installConstraints() {
        tableView.pinToSuperview()
        emptyResultsView.pinToSuperview()
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        emptyResultsView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
}

import UIKit

class EmptySearchResultsView: BuildableView {
    private let titleLabel = PortalLabel(size: 17, color: Branding.textColor(), text: "No results found.").aligned(.center)
    private let bodyLabel = PortalLabel(size: 15, color: Branding.textColor(), text: "Try your search again, or enter your address manually.").aligned(.center).withWrappedText()
    private let contentView: UIView = UIView()
    
    override var hierarchy: ViewHierarchy {
        return .view(contentView,
                     [.views([titleLabel, bodyLabel])])
    }

    override func installConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(280)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(5)
            make.width.equalTo(280)
            make.centerY.equalToSuperview()
        }
    }
    
    override func viewWillInitialize() {
        backgroundColor = .white
    }
}
