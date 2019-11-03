struct Address {
    let street: String
    let city: String
    let state: String
    let postalCode: String
    
    static func fromLocation(location: Location) -> Address {
        return Address(street: location.street, city: location.city, state: location.state, postalCode: location.zipcode)
    }
    func asString() -> String {
        return "\(street), \(city), \(city) \(postalCode)"
    }
}
