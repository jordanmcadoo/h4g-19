//
//  JobsService.swift
//  portal-to-work
//
//  Created by Benjamin Pomerenke on 11/2/19.
//  Copyright © 2019 arnold-pomers. All rights reserved.
//

import Foundation
import CoreLocation

class JobsService {
    var allJobs: [Job] = []
    
    init() {
        self.getData()
    }
    
    func getByLocation(location: CLLocation) -> [Job] {
        return self.allJobs
    }
    
    private func getData(){
        print("fetching data...")
        let url = URL(string: "https://jobs.api.sgf.dev/api/job?api_token=9ZGHl8yeQoaSBNUtwSlPaEJ1exTyWsRL7efirwhSlCmtGa1kCWSXgTSutK3Qqya3CchJpf2ANiiqTXP9")!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                 // Handle Error
                print("error: \(error)")
                return
             }
             guard let response = response else {
                 // Handle Empty Response
                print("response failed")
                return
             }
             guard let data = data else {
                 // Handle Empty Data
                 return
             }
             // Handle Decode Data into Model
            do {
                let result = try JSONDecoder().decode(JobData.self, from: data)

                print("loaded \(result.data.count) jobs")
                result.data.forEach { job in
                    let geoCoder = CLGeocoder()
                    let address = Address(street: "1227 W Cardinal", city: "Springfield", state: "MO", postalCode: "65810")
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
                        
                        self.allJobs.append(Job(title: job.title, employer: job.employer, lat: lat, lon: lon))
                        
                        print("geocoded \(job.title)")
                    }
                }
            } catch {
                print("failed decoding")
            }
        }.resume()
    }

}
