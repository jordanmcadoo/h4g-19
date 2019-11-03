import Foundation

struct EventData: Decodable {
    let data: [Event]
}

struct Event: Decodable {
    let title: String
    let description: String
    let dateBegin: String?
}
