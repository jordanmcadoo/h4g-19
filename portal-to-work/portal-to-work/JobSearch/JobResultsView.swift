import SnapKit

class JobResultsView: BuildableView {
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    override var hierarchy: ViewHierarchy {
        return .views([searchBar, tableView])
    }
    
    override func installConstraints() {
        searchBar.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.90)
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(10)
        }
    }
    
}
