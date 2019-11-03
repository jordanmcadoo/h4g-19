import SnapKit

class EventsView: BuildableView {
    let contentView = UIView()
    let tableView = UITableView()
    
    override var hierarchy: ViewHierarchy {
        return .view(contentView, [
            .views([tableView])
        ])
    }
    
    override func installConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.bottom.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
    }
    
}
