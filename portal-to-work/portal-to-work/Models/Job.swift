import CoreLocation

struct JobData: Decodable {
    let data: [Job]
}

struct Job: Decodable {
    let title: String
    let employer: Employer
    let lat: Double?
    let lon: Double?
}

struct Employer: Decodable {
    let name: String
}
