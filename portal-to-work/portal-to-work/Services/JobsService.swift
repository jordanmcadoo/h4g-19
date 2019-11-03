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
            self.getData { jobData, error in
                if let jobData = jobData {
                    seal.fulfill(jobData.data)
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
}
