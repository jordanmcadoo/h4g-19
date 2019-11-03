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
    var filteredData: [Job]!
    
    init(location: CLLocation, jobs: [Job]) {
        self.homeLocation = location
        self.allJobs = jobs
        self.visibleJobs = jobs.sort(byLocation: location).withinMiles(fromLocation: location, byMiles: 1.0)
        super.init(nibName: nil, bundle: nil)
        distanceButtons = [realView.oneMiButton, realView.fiveMiButton, realView.tenMiButton, realView.twentyMiButton, realView.thirtyMiButton]
        print("\(self.visibleJobs.count) jobs within 1.0 miles")
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Your Location"
        realView.mapView.addAnnotation(annotation)
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
        realView.oneMiButton.addTarget(self, action: #selector(oneMiTapped), for: .touchUpInside)
        realView.fiveMiButton.addTarget(self, action: #selector(fiveMiTapped), for: .touchUpInside)
        realView.tenMiButton.addTarget(self, action: #selector(tenMiTapped), for: .touchUpInside)
        realView.twentyMiButton.addTarget(self, action: #selector(twentyMiTapped), for: .touchUpInside)
        realView.thirtyMiButton.addTarget(self, action: #selector(thirtyMiTapped), for: .touchUpInside)
        let activeButton = realView.oneMiButton
        setButtonActive(activeButton)
        filteredData = visibleJobs
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = realView.tableView.indexPathForSelectedRow {
            realView.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    @objc private func oneMiTapped() {
        setButtonActive(realView.oneMiButton)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 1.0)
    }
    
    @objc private func fiveMiTapped() {
        setButtonActive(realView.fiveMiButton)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 5.0)
    }
    
    @objc private func tenMiTapped() {
        setButtonActive(realView.tenMiButton)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 10.0)
    }
    
    @objc private func twentyMiTapped() {
        setButtonActive(realView.twentyMiButton)
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 20.0)
    }
    
    @objc private func thirtyMiTapped() {
        setButtonActive(realView.thirtyMiButton)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        updateJobs(byMiles: 30.0)
        
    }
    
    private func updateJobs(byMiles miles: Double) {
        self.visibleJobs = allJobs.sort(byLocation: homeLocation).withinMiles(fromLocation: homeLocation, byMiles: miles)
        setupMap()
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
    
    private func setButtonActive(_ button: PortalSecondaryButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Branding.primaryColor()
        
        let otherButtons = distanceButtons.filter { $0 != button }
        otherButtons.forEach { setButtonInactive($0) }
    }
    
    private func setButtonInactive(_ button: PortalSecondaryButton) {
        button.setTitleColor(Branding.primaryColor(), for: .normal)
        button.backgroundColor = .clear
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

extension JobResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobResultsCell.reuseIdentifier) as! JobResultsCell
        let job = visibleJobs[indexPath.row]
        cell.setupWithJob(job, location: self.homeLocation)
        return cell
    }
}

extension JobResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = visibleJobs[indexPath.row]
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
}
