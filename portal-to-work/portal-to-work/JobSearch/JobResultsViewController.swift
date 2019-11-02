import UIKit
import CoreLocation

protocol JobResultsViewControllerDelegate: class {
    func jobResultsViewController(_: JobResultsViewController, didSelectJob: Job)
}

class JobResultsViewController: UIViewController {
    private let realView = JobResultsView()
    private let homeLocation: CLLocation
    weak var delegate: JobResultsViewControllerDelegate?

    let jobs = [Job(title: "Patient Transporter", employer: Employer(name: "Mercy Health"), description: "Oat cake bear claw marshmallow brownie. Soufflé icing cookie macaroon sweet roll sweet cupcake candy canes. Dragée lemon drops chocolate brownie fruitcake danish. Bonbon dragée jujubes muffin chocolate cake apple pie cookie pie."), Job(title: "Delivery Driver/Warehouse", employer: Employer(name: "Gold Mechanical"), description: "Apple pie dragée chocolate cake fruitcake. Jelly-o tootsie roll tart halvah chocolate lemon drops. Donut pie topping donut biscuit cheesecake chocolate cake."), Job(title: "Answering Service", employer: Employer(name: "QPS Employment Group"), description: "Icing pastry cookie tootsie roll candy canes sugar plum. Donut topping sweet. Soufflé gummi bears soufflé bonbon lemon drops.")]
    var filteredData: [Job]!
    
    init(location: CLLocation) {
        self.homeLocation = location
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
        realView.tableView.dataSource = self
        realView.tableView.delegate = self
        realView.tableView.register(JobResultsCell.self, forCellReuseIdentifier: JobResultsCell.reuseIdentifier)
        realView.searchBar.delegate = self
        filteredData = jobs
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = realView.tableView.indexPathForSelectedRow {
            realView.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
}

extension JobResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobResultsCell.reuseIdentifier) as! JobResultsCell
        let job = jobs[indexPath.row]
        cell.setupWithJob(job)
        return cell
    }
}

extension JobResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = jobs[indexPath.row]
        delegate?.jobResultsViewController(self, didSelectJob: job)
    }
}

extension JobResultsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? jobs : jobs.filter { (item: Job) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        realView.tableView.reloadData()
    }
}
