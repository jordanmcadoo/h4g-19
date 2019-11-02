import UIKit
import CoreLocation
import MapKit

protocol JobResultsViewControllerDelegate: class {
    func jobResultsViewController(_: JobResultsViewController, didSelectJob: Job)
}

class JobResultsViewController: UIViewController {
    private let realView = JobResultsView()
    private let homeLocation: CLLocation
    weak var delegate: JobResultsViewControllerDelegate?

    var jobs: [Job] = []
    var filteredData: [Job]!
    
    init(location: CLLocation, jobsService: JobsService) {
        self.homeLocation = location
        self.jobs = jobsService.getByLocation(location: location)
        super.init(nibName: nil, bundle: nil)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
            realView.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Your Location"
        realView.mapView.addAnnotation(annotation)
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
