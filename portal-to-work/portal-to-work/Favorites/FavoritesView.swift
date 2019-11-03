import SnapKit
import MapKit

class FavoritesView: BuildableView {
    let contentView = UIView()
    let tableView = UITableView()
    let noFavoritesView = PortalLabel(size: 22, text: "No favorites selected.").aligned(.center)
    
    override var hierarchy: ViewHierarchy {
        return .view(contentView, [
            .views([tableView, noFavoritesView])
        ])
    }
    
    override func installConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.bottom.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        noFavoritesView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
