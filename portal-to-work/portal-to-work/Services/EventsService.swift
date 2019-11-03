import Foundation
import CoreLocation
import PromiseKit

typealias EventsPromise = Promise<[Event]>
enum EventError: Error {
    case unknownError
}

class EventsService {
    init() {}
    
    func events() -> EventsPromise {
        return EventsPromise { seal in
            self.getData { eventData, error in
                if let eventData = eventData {
                    seal.fulfill(eventData.data)
                } else if let error = error {
                    seal.reject(error)
                } else {
                    seal.reject(JobError.unknownError)
                }
            }
        }
    }
    
    private func getData(completionHandler: @escaping (EventData?, Error?) -> Void) {
        print("fetching data...")
        let url = URL(string: "https://jobs.api.sgf.dev/api/event?api_token=9ZGHl8yeQoaSBNUtwSlPaEJ1exTyWsRL7efirwhSlCmtGa1kCWSXgTSutK3Qqya3CchJpf2ANiiqTXP9")!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                 // todo Handle Error
                print("error: \(error)")
                completionHandler(nil, error)
                return
             }
             guard let data = data else {
                 // todo Handle Empty Data
                 return
             }
            do {
                let result = try JSONDecoder().decode(EventData.self, from: data)

                print("loaded \(result.data.count) events")
                completionHandler(result, nil)
            } catch {
                print("failed decoding")
            }
        }.resume()
    }
}
