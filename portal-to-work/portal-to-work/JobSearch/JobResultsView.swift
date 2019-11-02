import SnapKit
import MapKit

class JobResultsView: BuildableView {
    let contentView = UIView()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let mapView = MKMapView()
    
    override var hierarchy: ViewHierarchy {
        return .view(contentView, [
            .views([searchBar, mapView, tableView])
        ])
    }
    
    override func installConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.bottom.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.90)
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.90)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(10)
        }
    }
    
}
