import UIKit
import MapKit
import Contacts

class JobDetailViewController: UIViewController {
    private let realView = JobDetailView()
    private let job: Job
    
    init(job: Job) {
        self.job = job
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
        navigationItem.title = "JOB DETAILS"
        configureView()
        realView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        realView.lessButton.addTarget(self, action: #selector(lessButtonTapped), for: .touchUpInside)
    }
    
    @objc private func moreButtonTapped() {
        realView.descriptionLabel.lineBreakMode = .byWordWrapping
        realView.descriptionLabel.numberOfLines(0)
        realView.moreButton.isHidden = true
        realView.lessButton.isHidden = false
        realView.layoutIfNeeded()
    }
    
    @objc private func lessButtonTapped() {
        realView.descriptionLabel.lineBreakMode = .byTruncatingTail
        realView.descriptionLabel.numberOfLines(1)
        realView.moreButton.isHidden = false
        realView.lessButton.isHidden = true
        realView.layoutIfNeeded()
    }
    
    private func configureView() {
        realView.jobTitle.text = job.title
        realView.employer.text = job.employer.name
        realView.descriptionLabel.setHTMLFromString(htmlText: job.tempDescription())
        
        setupMapView()
    }
    
    private func setupMapView() {
        guard let location = job.locations.data.at(0), let latStr = location.lat, let lngStr = location.lng, let lat = Double(latStr), let lng = Double(lngStr) else {
            return
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = job.employer.name
        annotation.subtitle = Address.fromLocation(location: location).asString()
        realView.mapView.addAnnotation(annotation)
    }
}

extension JobDetailViewController: MKMapViewDelegate {
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
