import UIKit
import CoreLocation

class JobResultsViewController: UIViewController {
    let realView = JobResultsView()
    private let homeLocation: CLLocation

    let testData = [Job(title: "Patient Transporter", employer: Employer(name: "Mercy Health")), Job(title: "Delivery Driver/Warehouse", employer: Employer(name: "Gold Mechanical")), Job(title: "Answering Service", employer: Employer(name: "QPS Employment Group"))]
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
        realView.tableView.register(JobResultsCell.self, forCellReuseIdentifier: JobResultsCell.reuseIdentifier)
        realView.searchBar.delegate = self
        filteredData = testData
    }
}

extension JobResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobResultsCell.reuseIdentifier) as! JobResultsCell
        let job = testData[indexPath.row]
        cell.setupWithJob(job)
        return cell
    }
}

extension JobResultsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? testData : testData.filter { (item: Job) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        realView.tableView.reloadData()
    }
}
