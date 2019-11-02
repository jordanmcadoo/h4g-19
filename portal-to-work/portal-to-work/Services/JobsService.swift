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
                let myStruct = try JSONDecoder().decode(JobData.self, from: data)
                self.allJobs = myStruct.data
                print("loaded \(self.allJobs.count) jobs")
            } catch {
                print("failed decoding")
            }
        }.resume()
    }

}
