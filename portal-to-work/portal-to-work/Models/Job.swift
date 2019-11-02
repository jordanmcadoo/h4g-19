import CoreLocation

struct JobData: Decodable {
    let data: [Job]
}

struct Job: Decodable {
    let title: String
    let employer: Employer
    let description: String?
    let locations: LocationData
    let lat: Double?
    let lon: Double?
    let distanceInMiles: Double?
}
struct LocationData: Decodable {
    let data: [Location]
}
struct Location: Decodable {
    let street: String
    let city: String
    let state: String
    let zipcode: String
}

struct Employer: Decodable {
    let name: String
}
