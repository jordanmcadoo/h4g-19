import CoreLocation

struct JobData: Decodable {
    let data: [Job]
}

struct Job: Decodable {
    let title: String
    let employer: Employer
    let description: String?
    let locations: LocationData
    let url: String
    
    func distanceInMiles(fromLocation: CLLocation) -> Double? {
        guard let location = self.locations.data.at(0) else {
            return nil
        }
        guard let latString = location.lat, let lat = Double.init(latString) else {
            return nil
        }
        guard let lngString = location.lng, let lng = Double.init(lngString) else {
            return nil
        }
        let distance = fromLocation.distance(from: CLLocation(latitude: lat, longitude: lng))
        return distance * 0.000621371
    }
    
    func tempDescription() -> String {
        return description ?? generateRandomDescription()
    }
    
    private func generateRandomDescription() -> String {
        let first = "Jelly beans marzipan chocolate marzipan chocolate bar bear claw. Tootsie roll sweet cheesecake gingerbread biscuit chupa chups soufflé liquorice. Tiramisu gummi bears dessert bonbon carrot cake."
        let second = "Soufflé tiramisu chocolate powder oat cake marshmallow. Cheesecake cookie chupa chups cheesecake muffin pastry cake. Gingerbread brownie bonbon sweet chocolate."
        let third = "Donut dragée pudding cake sugar plum halvah cotton candy cheesecake sugar plum. Gummies sugar plum tiramisu. Pudding ice cream liquorice sweet roll. Soufflé sugar plum sugar plum."
        let fourth = "Marshmallow apple pie cupcake. Oat cake ice cream brownie gummies apple pie topping. Macaroon gingerbread pie sugar plum sugar plum apple pie pudding carrot cake."
        let fifth = "Carrot cake dragée pudding. Icing bear claw pastry chocolate marzipan. Chupa chups gummies bonbon apple pie chocolate pie."
        
        return [first, second, third, fourth, fifth].randomElement() ?? ""
    }
}

struct LocationData: Decodable {
    let data: [Location]
}

struct Location: Decodable {
    let street: String
    let city: String
    let state: String
    let zipcode: String
    let lat: String?
    let lng: String?
}

struct Employer: Decodable {
    let name: String
}

extension Array where Element == Job {
    func withinMiles(fromLocation: CLLocation, byMiles: Double) -> [Job] {
        return self.filter({ job -> Bool in
            guard let distanceInMiles = job.distanceInMiles(fromLocation: fromLocation) else {
                return false
            }
            return distanceInMiles < byMiles
        })
    }
    
    func sort(byLocation location: CLLocation) -> [Job] {
        return self.sorted(by: { job1, job2 -> Bool in
            guard let location1 = job1.locations.data.at(0) else {
                return true
            }
            guard let location2 = job1.locations.data.at(0) else {
                return false
            }
            guard let lat1String = location1.lat, let lat1 = Double.init(lat1String) else {
                return true
            }
            guard let lng1String = location1.lng, let lng1 = Double.init(lng1String) else {
                return true
            }
            guard let lat2String = location2.lat, let lat2 = Double.init(lat2String) else {
                return false
            }
            guard let lng2String = location2.lng, let lng2 = Double.init(lng2String) else {
                return false
            }
            
            let distance1 = location.distance(from: CLLocation(latitude: lat1, longitude: lng1))
            let distance2 = location.distance(from: CLLocation(latitude: lat2, longitude: lng2))
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
}
