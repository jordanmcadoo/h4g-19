import Foundation

struct EventData: Decodable {
    let data: [Event]
}

struct Event: Decodable {
    let title: String
    let description: String
    let date_begin: String?
    let phone: String?
    let email: String?
    let cost: Double
    let location: EventLocation
}

struct EventLocation: Decodable {
    let street: String
    let city: String
    let state: String
    let zipcode: String
    let lat: String?
    let lng: String?
}
