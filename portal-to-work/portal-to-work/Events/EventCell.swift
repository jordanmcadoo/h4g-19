import UIKit

class EventCell: UITableViewCell {
    static let reuseIdentifier = "EventCell"
    private let eventTitle = PortalLabel(desiredFont: UIFont.boldSystemFont(ofSize: 18), size: 18)
    private let eventDescription = PortalLabel().withLines(3)
    private let eventDate = PortalLabel(desiredFont: UIFont.italicSystemFont(ofSize: 10), size: 10)
    private let eventCost = PortalLabel(desiredFont: UIFont.italicSystemFont(ofSize: 10), size: 10)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setUpViews()
        initializeConstraints()
    }

    private func setUpViews() {
        contentView.safelyAddSubview(eventTitle)
        contentView.safelyAddSubview(eventDescription)
        contentView.safelyAddSubview(eventDate)
        contentView.safelyAddSubview(eventCost)
    }

    private func initializeConstraints() {
        eventTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }
        
        eventDescription.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(eventDate.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
        }
        eventDate.snp.makeConstraints{
            $0.top.equalTo(eventTitle.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(20)
        }
        eventCost.snp.makeConstraints{
            $0.top.equalTo(eventTitle.snp.bottom).offset(4)
            $0.leading.equalTo(eventDate.snp.trailing).offset(20)
        }

        eventTitle.setContentCompressionResistancePriority(.required, for: .vertical)
        eventTitle.setContentHuggingPriority(.required, for: .vertical)
    }

    func setupWithEvent(_ event: Event) {
        eventTitle.text = event.title
        eventDescription.text = event.description
        eventCost.text = "$\(event.cost)0"
        eventDate.text = event.date_begin
    }
}
