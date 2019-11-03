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
        realView.linkToApply.addTarget(self, action: #selector(linkToApplyTapped), for: .touchUpInside)
        
        guard let location = job.locations.data.at(0) else {
            return
        }
        guard let latString = location.lat, let lat = Double(latString), let lngString = location.lng, let lng = Double(lngString) else {
            return
        }
        let coordinate = CLLocation(latitude: lat, longitude: lng).coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
            realView.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = job.title
        annotation.subtitle = Address.fromLocation(location: job.locations.data[0]).asString()
        realView.mapView.addAnnotation(annotation)
        
        realView.mapView.delegate = self
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
    @objc private func linkToApplyTapped() {
        if let url = URL(string: job.url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func configureView() {
        realView.jobTitle.text = job.title
        realView.employer.text = job.employer.name
        realView.descriptionLabel.setHTMLFromString(htmlText: job.tempDescription())
    }
}

extension JobDetailViewController: MKMapViewDelegate {
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
//                let customPin = UIImage(named: "home2.png")
//                annotationView!.image = customPin
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
