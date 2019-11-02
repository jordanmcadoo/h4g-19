import Foundation
import SmartystreetsSDK
import PromiseKit

typealias SmartyStreetsAutocompleteSuggestion = SSUSAutocompleteSuggestion
typealias SmartyStreetsStreetCandidate = SSUSStreetCandidate
typealias SmartyStreetsStreetComponents = SSUSStreetComponents
typealias SmartyStreetsAutocompleteLookup = SSUSAutocompleteLookup
typealias SmartyStreetsStreetLookup = SSUSStreetLookup
typealias SmartyStreetsAutocompletePromise = Promise<[SmartyStreetsAutocompleteSuggestion]>

protocol SmartyStreetsService_Protocol {
    func search(query: String, autocompleteClient: StitchFixSSUSAutocompleteClient_Protocol?, autocompleteLookup: SSUSAutocompleteLookup) -> SmartyStreetsAutocompletePromise
    func detail(from query: SmartyStreetsAutocompleteSuggestion, streetClient: PortalSSUSStreetClient_Protocol?, streetLookup: SSUSStreetLookup) -> Promise<Address>
}

protocol PortalSSUSStreetClient_Protocol {
    func send(_ lookup: SSUSStreetLookup!) throws
}
extension SSUSStreetClient: PortalSSUSStreetClient_Protocol {}

extension SmartyStreetsService_Protocol {
    func search(query: String, autocompleteClient: StitchFixSSUSAutocompleteClient_Protocol? = SSClientBuilder(signer: credentials).buildUsAutocompleteApiClient(), autocompleteLookup: SSUSAutocompleteLookup = SSUSAutocompleteLookup()) -> SmartyStreetsAutocompletePromise {
        return search(query: query, autocompleteClient: autocompleteClient, autocompleteLookup: autocompleteLookup)
    }
    
    func detail(from query: SmartyStreetsAutocompleteSuggestion, streetClient: PortalSSUSStreetClient_Protocol? = SSClientBuilder(signer: credentials).buildUsStreetApiClient(), streetLookup: SSUSStreetLookup = SSUSStreetLookup()) -> Promise<Address> {
        return detail(from: query, streetClient: streetClient, streetLookup: streetLookup)
    }
}

enum SmartyStreetsError: Error {
    case invalidResults
    case emptyResult
}

protocol StitchFixSSUSAutocompleteClient_Protocol {
    func send(_ lookup: SSUSAutocompleteLookup!) throws
}
extension SSUSAutocompleteClient: StitchFixSSUSAutocompleteClient_Protocol {}

protocol StitchFixSSUSStreetClient_Protocol {
    func send(_ lookup: SSUSStreetLookup!) throws
}
extension SSUSStreetClient: StitchFixSSUSStreetClient_Protocol {}

fileprivate let credentials = SSSharedCredentials(id: "ID", hostname: "Hostname")
class SmartyStreetsService: SmartyStreetsService_Protocol {
    init() {}
    
    func search(query: String, autocompleteClient: StitchFixSSUSAutocompleteClient_Protocol?, autocompleteLookup: SSUSAutocompleteLookup) -> SmartyStreetsAutocompletePromise {
        autocompleteLookup.prefix = query
        
        return SmartyStreetsAutocompletePromise { seal in
            let queue = DispatchQueue.global(qos: .background)
            queue.async { [weak self] in
                do {
                    try autocompleteClient?.send(autocompleteLookup)
                    guard let result = autocompleteLookup.result as? [SmartyStreetsAutocompleteSuggestion] else {
                        DispatchQueue.main.async {
                            seal.reject(SmartyStreetsError.invalidResults)
                        }
                        return
                    }
                    
                    if result.count == 0 {
                        DispatchQueue.main.async {
                            seal.reject(SmartyStreetsError.emptyResult)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        seal.fulfill(result)
                    }
                } catch let error as NSError {
                    print("error: \(error)")
                }
            }
        }
    }
    
    func detail(from query: SmartyStreetsAutocompleteSuggestion, streetClient: PortalSSUSStreetClient_Protocol?, streetLookup: SSUSStreetLookup) -> Promise<Address> {
        streetLookup.street = query.streetLine
        streetLookup.city = query.city
        streetLookup.state = query.state
        
        return Promise<Address> { seal in
            let queue = DispatchQueue.global(qos: .background)
            queue.async { [weak self] in
                do {
                    try streetClient?.send(streetLookup)
                    guard let results = streetLookup.result as? [SmartyStreetsStreetCandidate], let result = results.last else {
                        DispatchQueue.main.async {
                            seal.reject(SmartyStreetsError.invalidResults)
                        }
                        return
                    }

                    let address = "\(result.components.primaryNumber ?? "") \(result.components.streetName ?? "") \(result.components.streetSuffix ?? "")"
                    let shippingAddress = Address(address: address, city: result.components.cityName, state: result.components.state, postcode: result.components.state)
                    DispatchQueue.main.async {
                        seal.fulfill(shippingAddress)
                    }
                } catch let error as NSError {
                    // todo
                }
            }
        }
    }
}
