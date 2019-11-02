import Foundation
import CoreLocation

class JobsService {
    var allJobs: [Job] = []
    
    init() {
        self.getData()
    }
    
    func getByLocation(location: CLLocation) -> [Job] {
        return allJobs.sorted(by: { job1, job2 -> Bool in
            let distance1 = location.distance(from: CLLocation(latitude: job1.lat!, longitude: job1.lon!))
            let distance2 = location.distance(from: CLLocation(latitude: job2.lat!, longitude: job2.lon!))
            return distance1 > distance2
        })
        
//        var filteredJobs: [Job] = []
//        self.allJobs.forEach { job in
//            let distance = location.distance(from: CLLocation(latitude: job.lat!, longitude: job.lon!))
//            let distanceInMiles = distance * 0.000621371
//            print("distance: \(distanceInMiles)")
//
//            if distanceInMiles < 5.0 {
//                filteredJobs.append(Job(title: job.title, employer: job.employer, description: job.description, locations: job.locations, lat: job.lat, lon: job.lon, distanceInMiles: distanceInMiles))
//            }
//        }
        
//        return filteredJobs
    }
    
    private func getData() {
        print("fetching data...")
        let url = URL(string: "https://jobs.api.sgf.dev/api/job?api_token=9ZGHl8yeQoaSBNUtwSlPaEJ1exTyWsRL7efirwhSlCmtGa1kCWSXgTSutK3Qqya3CchJpf2ANiiqTXP9")!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                 // todo Handle Error
                print("error: \(error)")
                return
             }
             guard let data = data else {
                 // todo Handle Empty Data
                 return
             }
            do {
                let result = try JSONDecoder().decode(JobData.self, from: data)

                print("loaded \(result.data.count) jobs")
                result.data.forEach { job in
                    if job.locations.data.count < 1 {
                        print("skipping location for \(job.title)")

//                        self.allJobs.append(Job(title: job.title, employer: job.employer, locations: job.locations, lat: nil, lon: nil))
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
          
                        self.allJobs.append(Job(title: job.title, employer: job.employer, description: job.description, locations: job.locations, lat: lat, lon: lon, distanceInMiles: nil))

                        print("geocoded \(job.title)")
                    }
                }
            } catch {
                print("failed decoding")
            }
        }.resume()
    }
}
