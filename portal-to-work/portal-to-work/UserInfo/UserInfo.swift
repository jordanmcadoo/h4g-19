import MapKit

class UserInfo {
    static let shared = UserInfo()
    private init() {}
    var location =  CLLocation(latitude: CLLocationDegrees(exactly: 37.2119519)!, longitude: CLLocationDegrees(exactly: -93.290407)!)
}
