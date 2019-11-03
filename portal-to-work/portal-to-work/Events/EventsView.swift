import SnapKit

class EventsView: BuildableView {
    let contentView = UIView()
    let tableView = UITableView()
    let spinner = UIActivityIndicatorView()
    
    override var hierarchy: ViewHierarchy {
        return .view(contentView, [
            .views([tableView,
                    spinner])
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
