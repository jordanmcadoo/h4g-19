import UIKit
import MapKit
import Contacts

class EventsViewController: UIViewController {
    private let realView = EventsView()
    let homeLocation: CLLocation
    var events: [Event] = [] {
        didSet {
            realView.tableView.reloadData()
            self.events.forEach { event in
                guard let latString = event.location.lat, let lat = Double(latString), let lngString = event.location.lng, let lng = Double(lngString) else {
                    print("no location for event \(event.title)")
                    return
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double.init(lat), longitude: Double.init(lng))
                annotation.title = event.title
                annotation.subtitle = Address.fromEventLocation(location: event.location).asString()
                realView.mapView.addAnnotation(annotation)
            }
            
        }
    }
    
    init() {
        homeLocation = UserInfo.shared.location
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
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: homeLocation.coordinate, span: span)
        realView.mapView.setRegion(region, animated: true)
        realView.mapView.delegate = self
        
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
        let event = events[indexPath.row]
        let annotation = realView.mapView.annotations.first(where: { $0.title == event.title })
        if let annotation = annotation {
            realView.mapView.selectAnnotation(annotation, animated: true)
        }
    }
}


extension EventsViewController: MKMapViewDelegate {
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
