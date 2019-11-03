import SnapKit
import MapKit

class EventsView: BuildableView {
    let contentView = UIView()
    let tableView = UITableView()
    let spinner = UIActivityIndicatorView()
    let mapView = MKMapView()
    
    override var hierarchy: ViewHierarchy {
        return .view(contentView, [
            .views([tableView, mapView,
                    spinner])
        ])
    }
    
    override func installConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.bottom.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        mapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.height.equalTo(200)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(mapView.snp.bottom).offset(20)
        }
        
        spinner.color = .black
        if #available(iOS 13.0, *) {
            spinner.style = .large
        } else {
            // Fallback on earlier versions
        }
        spinner.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
