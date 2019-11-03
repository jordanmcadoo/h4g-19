import Foundation
import CoreLocation
import PromiseKit

typealias JobPromise = Promise<[Job]>
enum JobError: Error {
    case unknownError
}

class JobsService {
    var allJobs: [Job] = []
    
    init() {}
    
    func jobs() -> JobPromise {
        return JobPromise { seal in
            self.getData { jobs, error in
                if let jobs = jobs {
                    seal.fulfill(self.setLatLong(forJobData: jobs))
                } else if let error = error {
                    seal.reject(error)
                } else {
                    seal.reject(JobError.unknownError)
                }
            }
        }
    }
    
    func getData(completionHandler: @escaping (JobData?, Error?) -> Void) {
        print("fetching data...")
        let url = URL(string: "https://jobs.api.sgf.dev/api/job?api_token=9ZGHl8yeQoaSBNUtwSlPaEJ1exTyWsRL7efirwhSlCmtGa1kCWSXgTSutK3Qqya3CchJpf2ANiiqTXP9")!
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
                let result = try JSONDecoder().decode(JobData.self, from: data)

                print("loaded \(result.data.count) jobs")
                completionHandler(result, nil)
            } catch {
                print("failed decoding")
            }
        }.resume()
    }
    
    private func setLatLong(forJobData jobData: JobData) -> [Job] {
        var jobs = [Job]()
        
        jobData.data.forEach { job in
            if (job.lat != nil) && (job.lon != nil) {
                jobs.append(job)
                return
            }
            if job.locations.data.count < 1 {
                print("skipping location for \(job.title)")
                return
            }
            let geoCoder = CLGeocoder()
            let address = Address(street: job.locations.data[0].street, city: job.locations.data[0].city, state: job.locations.data[0].state, postalCode: job.locations.data[0].zipcode)

            geoCoder.geocodeAddressString(address.asString()) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                else {
                    // todo handle no location found
                    return
                }

                let lat = location.coordinate.latitude as Double
                let lon = location.coordinate.longitude as Double
                jobs.append(Job(title: job.title, employer: job.employer, description: job.description, locations: job.locations, lat: lat, lon: lon, distanceInMiles: nil))
                print("geocoded \(job.title)")
            }
        }
        
        return jobs
    }
}
