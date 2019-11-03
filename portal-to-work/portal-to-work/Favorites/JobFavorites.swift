class JobFavorites {
    static let shared = JobFavorites()
    private init() {}
    private(set) var favorites: [Job] = []
    
    func updateFavorite(for job: Job) {
        if favorites.contains(job) {
            favorites = favorites.filter { $0 != job }
        } else {
            favorites.append(job)
        }
    }
}
