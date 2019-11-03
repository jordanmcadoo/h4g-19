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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.endEditing(true)
    }
    
    @objc private func useCurrentLocationTapped() {
        startSpinnner()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        } else {
            stopSpinnner()
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

            UserInfo.shared.location = location
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
    
    func startSpinnner() {
        realView.spinner.startAnimating()
        realView.useCurrentAddressButton.isEnabled = false
        realView.addressForm.isUserInteractionEnabled = false
        realView.addressForm.useManualAddressButton.isEnabled = false
    }
    
    func stopSpinnner() {
        realView.spinner.stopAnimating()
        realView.useCurrentAddressButton.isEnabled = true
        realView.addressForm.isUserInteractionEnabled = true
        realView.addressForm.useManualAddressButton.isEnabled = true
    }
}

extension JobSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            UserInfo.shared.location = location
            delegate?.jobSearchViewController(self, didReceiveLocation: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        stopSpinnner()
    }
}
