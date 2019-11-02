struct JobData: Decodable {
    let data: [Job]
}

struct Job: Decodable {
    let title: String
    let employer: Employer
}

struct Employer: Decodable {
    let name: String
}
