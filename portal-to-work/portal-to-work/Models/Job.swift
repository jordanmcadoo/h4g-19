import CoreLocation

struct JobData: Decodable {
    let data: [Job]
}

struct Job: Decodable, Equatable {
    let title: String
    let employer: Employer
    let description: String?
    let locations: LocationData
    let payRate: String?
    let jobType: String?
    let reqEducation: String?
    let url: String?
    
    func isFavorite() -> Bool {
        return JobFavorites.shared.favorites.contains(self)
    }
    
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

struct LocationData: Decodable, Equatable {
    let data: [Location]
}

struct Location: Decodable, Equatable {
    let street: String
    let city: String
    let state: String
    let zipcode: String
    let lat: String?
    let lng: String?
}

struct Employer: Decodable, Equatable {
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
            guard let distance1 = job1.distanceInMiles(fromLocation: location), let distance2 = job2.distanceInMiles(fromLocation: location) else {
                if let _ = job1.distanceInMiles(fromLocation: location) { return false }
                return true
            }
            return distance1 < distance2
        
        })
    }
}
