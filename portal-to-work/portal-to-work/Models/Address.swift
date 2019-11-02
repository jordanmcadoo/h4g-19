struct Address {
    let street: String
    let city: String
    let state: String
    let postalCode: String
    
    func asString() -> String {
        return "\(street), \(city), \(city) \(postalCode)"
    }
}
