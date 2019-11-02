import UIKit
import SnapKit
import CoreLocation

protocol JobSearchViewControllerDelegate: class {
    func jobSearchViewController(_: JobSearchViewController, didReceiveLocation: CLLocation)
}

class JobSearchViewController: UIViewController {
    let realView = JobSearchView()
    let locationManager = CLLocationManager()
    weak var delegate: JobSearchViewControllerDelegate?
    
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
        navigationItem.title = "Find Jobs"
        realView.useCurrentAddressButton.addTarget(self, action: #selector(useCurrentLocationTapped), for: .touchUpInside)
        realView.addressForm.useManualAddressButton.addTarget(self, action: #selector(useManualLocationTapped), for: .touchUpInside)
    }
    
    @objc private func useCurrentLocationTapped() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @objc private func useManualLocationTapped() {
        guard let address = fetchAddressFromForm()?.asString() else {
            // todo error
            return
        }

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // todo handle no location found
                return
            }

            print(location)
            self.delegate?.jobSearchViewController(self, didReceiveLocation: location)
        }
    }
    
    private func fetchAddressFromForm() -> Address? {
        let validator = AddressFormViewValidator()
        guard let address = validator.validateRequiredFields(realView.addressForm) else {
            return nil
        }
        
        return address
    }
}

extension JobSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            delegate?.jobSearchViewController(self, didReceiveLocation: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        // todo - error
    }
}
