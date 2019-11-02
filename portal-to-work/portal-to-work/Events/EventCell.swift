import UIKit

class EventCell: UITableViewCell {
    static let reuseIdentifier = "EventCell"
    private let eventTitle = PortalLabel()
    private let eventDescription = PortalLabel().withLines(3)

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
    }

    private func initializeConstraints() {
        eventTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }

        eventDescription.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(eventTitle.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
        }

        eventTitle.setContentCompressionResistancePriority(.required, for: .vertical)
        eventTitle.setContentHuggingPriority(.required, for: .vertical)
    }

    func setupWithEvent(_ event: Event) {
        eventTitle.text = event.title
        eventDescription.text = event.description
    }
}

//class EventCell: UITableViewCell {
//    static let reuseIdentifier = "EventCell"
//
//    var titleLabel: UILabel!
//    var descriptionLabel: UILabel!
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.configure()
//    }
//
//    func configure() {
//        titleLabel = UILabel()
//        descriptionLabel = UILabel().withLines(3)
//        titleLabel.backgroundColor = .cyan
//        descriptionLabel.backgroundColor = .yellow
//
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(descriptionLabel)
//
//        titleLabel.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.top.equalToSuperview().inset(10)
//        }
//
//        descriptionLabel.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
//            $0.bottom.equalToSuperview().inset(10)
//        }
//
//        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
//        titleLabel.setContentHuggingPriority(.required, for: .vertical)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupWithEvent(_ event: Event) {
//        titleLabel.text = event.title
//        descriptionLabel.text = event.description
//    }
//}
