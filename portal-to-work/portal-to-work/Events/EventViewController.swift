import UIKit

class EventsViewController: UIViewController {
    private let realView = EventsView()
    var events: [Event] = [] {
        didSet {
            realView.tableView.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = realView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Events"
        realView.tableView.dataSource = self
        realView.tableView.delegate = self
        realView.tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = realView.tableView.indexPathForSelectedRow {
            realView.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    func startSpinnner() {
        realView.spinner.startAnimating()
    }
    
    func stopSpinnner() {
        realView.spinner.stopAnimating()
    }
}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier) as! EventCell
        let event = events[indexPath.row]
        cell.setupWithEvent(event)
        return cell
    }
}

extension EventsViewController: UITableViewDelegate {
func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
      return 55
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    return UITableView.automaticDimension
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let event = events[indexPath.row]
    }
}
