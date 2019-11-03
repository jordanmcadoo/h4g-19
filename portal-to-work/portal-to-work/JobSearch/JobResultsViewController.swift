import UIKit
import CoreLocation
import MapKit
import Contacts

protocol JobResultsViewControllerDelegate: class {
    func jobResultsViewController(_: JobResultsViewController, didSelectJob: Job)
}

class JobResultsViewController: UIViewController {
    private let realView = JobResultsView()
    private var distanceButtons: [PortalSecondaryButton] = []
    private let homeLocation: CLLocation
    weak var delegate: JobResultsViewControllerDelegate?

    let allJobs: [Job]
    var visibleJobs: [Job]
    var filteredData: [Job]
    
    init(location: CLLocation, jobs: [Job]) {
        self.homeLocation = location
        self.allJobs = jobs
        self.visibleJobs = jobs.sort(byLocation: location).withinMiles(fromLocation: location, byMiles: 1.0)
        self.filteredData = visibleJobs
        super.init(nibName: nil, bundle: nil)
        print("\(self.visibleJobs.count) jobs within 1.0 miles")
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        realView.mapView.delegate = self
        realView.segmentedControl.selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            realView.segmentedControl.selectedSegmentTintColor = Branding.primaryColor()
        } else {
            // Fallback on earlier versions
        }
        
        setupMap()
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
        realView.segmentedControl.addTarget(self, action: #selector(distanceFilterTapped), for: .allEvents)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = homeLocation.coordinate
        annotation.title = "Your Location"
        realView.mapView.addAnnotation(annotation)
        realView.mapView.selectAnnotation(annotation, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = realView.tableView.indexPathForSelectedRow {
            realView.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    @objc private func distanceFilterTapped() {
        switch realView.segmentedControl.selectedSegmentIndex {
        case 0: oneMiTapped()
        case 1: fiveMiTapped()
        case 2: tenMiTapped()
        case 3: twentyMiTapped()
        case 4: thirtyMiTapped()
        default:
            return
        }
    }
    
    private func oneMiTapped() {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 1.0)
    }
    
    private func fiveMiTapped() {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 5.0)
    }
    
    private func tenMiTapped() {
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 10.0)
    }
    
    private func twentyMiTapped() {
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 20.0)
    }
    
    private func thirtyMiTapped() {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 30.0)
        
    }
    
    private func updateJobs(byMiles miles: Double) {
        realView.searchBar.resignFirstResponder()
        realView.searchBar.text = nil
        self.visibleJobs = allJobs.sort(byLocation: homeLocation).withinMiles(fromLocation: homeLocation, byMiles: miles)
        filteredData = visibleJobs
        setupMap()
        realView.tableView.reloadData()
    }
    
    private func setupMap() {
        let jobAnnotations = realView.mapView.annotations.filter { $0.title != "Your Location" }
        realView.mapView.removeAnnotations(jobAnnotations)
        self.visibleJobs.forEach { job in
            guard let location = job.locations.data.at(0), let latStr = location.lat, let lngStr = location.lng, let lat = Double(latStr), let lng = Double(lngStr) else {
                return
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            annotation.title = job.title
            annotation.subtitle = Address.fromLocation(location: job.locations.data[0]).asString()
            realView.mapView.addAnnotation(annotation)
        }
    }
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
                let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinAnnotationView.pinTintColor = Branding.primaryColor()
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView = pinAnnotationView
            } else {
                let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView = pinAnnotationView
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

extension JobResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobResultsCell.reuseIdentifier) as! JobResultsCell
        let job = filteredData[indexPath.row]
        cell.setupWithJob(job, location: self.homeLocation)
        return cell
    }
}

extension JobResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = filteredData[indexPath.row]
        delegate?.jobResultsViewController(self, didSelectJob: job)
    }
}

extension JobResultsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? visibleJobs : visibleJobs.filter { (item: Job) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        realView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
