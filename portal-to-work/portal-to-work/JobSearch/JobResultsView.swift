import SnapKit
import MapKit

class JobResultsView: BuildableView {
    let contentView = UIView()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let mapView = MKMapView()
    let oneMiButton = PortalSecondaryButton(title: "1 mi")
    let fiveMiButton = PortalSecondaryButton(title: "5 mi")
    let tenMiButton = PortalSecondaryButton(title: "10 mi")
    let twentyMiButton = PortalSecondaryButton(title: "20 mi")
    let thirtyMiButton = PortalSecondaryButton(title: "30 mi")

    override var hierarchy: ViewHierarchy {
        return .view(contentView, [
            .views([searchBar, mapView, oneMiButton, fiveMiButton, tenMiButton, twentyMiButton, thirtyMiButton, tableView])
        ])
    }
    
    override func installConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.bottom.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        oneMiButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.trailing.equalTo(fiveMiButton.snp.leading).offset(-5)
        }
        fiveMiButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.trailing.equalTo(tenMiButton.snp.leading).offset(-5)
        }
        tenMiButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        twentyMiButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.leading.equalTo(tenMiButton.snp.trailing).offset(5)
            
        }
        thirtyMiButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.leading.equalTo(twentyMiButton.snp.trailing).offset(5)
            
        }
        
        searchBar.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.90)
            make.top.equalTo(oneMiButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(10)
        }
    }
    
}
