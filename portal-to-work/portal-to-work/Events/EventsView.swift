import SnapKit

class EventsView: BuildableView {
    let contentView = UIView()
    private let title = PortalLabel(text: "EVENTS").aligned(.center).withLines(3)
    let tableView = UITableView()
    
    override var hierarchy: ViewHierarchy {
        return .view(contentView, [
            .views([title, tableView])
        ])
    }
    
    override func installConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.bottom.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(10)
        }
    }
    
}
