import UIKit
import CoreLocation
import MapKit
import Contacts

protocol JobResultsViewControllerDelegate: class {
    func jobResultsViewController(_: JobResultsViewController, didSelectJob: Job)
}

extension JobResultsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            print("returning nil")
            return nil
        }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            if annotation.title != "Your Location" {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                annotationView!.tintColor = .blue
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        } else {
            annotationView!.annotation = annotation
            print("couldnt get view")
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
        print("callout tapped")
        let location = view.annotation as! MKPointAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let addressDict = [CNPostalAddressStreetKey: location.subtitle!]
        let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title

        mapItem.openInMaps(launchOptions: launchOptions)
    }
}

class JobResultsViewController: UIViewController {
    private let realView = JobResultsView()
    private let homeLocation: CLLocation
    weak var delegate: JobResultsViewControllerDelegate?

    let jobs: [Job]
    var filteredData: [Job]!
    
    init(location: CLLocation, jobs: [Job]) {
        self.homeLocation = location
        self.jobs = jobs.sort(byLocation: location).withinMiles(fromLocation: location, byMiles: 1.0)
        super.init(nibName: nil, bundle: nil)
        
        print("\(self.jobs.count) jobs within 1.0 miles")
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
            realView.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Your Location"
        realView.mapView.addAnnotation(annotation)
        
        self.jobs.forEach{ job in
            guard let location = job.locations.data.at(0) else {
                return
            }
            guard let lat = location.lat, let lng = location.lng else {
                return
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double.init(lat)!, longitude: Double.init(lng)!)
            annotation.title = job.title
            annotation.subtitle = Address.fromLocation(location: job.locations.data[0]).asString()
            realView.mapView.addAnnotation(annotation)
        }
        
        realView.mapView.delegate = self
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
        realView.oneMiButton.setTitleColor(.white, for: .normal)
        realView.oneMiButton.backgroundColor = Branding.primaryColor()
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
        cell.setupWithJob(job, location: self.homeLocation)
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
