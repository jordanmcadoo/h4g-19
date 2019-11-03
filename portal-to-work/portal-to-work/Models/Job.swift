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
}

struct Employer: Decodable {
    let name: String
}

extension Array where Element == Job {
    func sort(byLocation location: CLLocation) -> [Job] {
        return self.sorted(by: { job1, job2 -> Bool in
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
}
