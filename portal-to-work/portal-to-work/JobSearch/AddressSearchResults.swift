import Foundation

protocol AddressSearchResultsDelegate: class {
    func addressSearchResults(_ searchResults: AddressSearchResults_Protocol, didUpdateResults results: [SmartyStreetsAutocompleteSuggestion])
}

protocol AddressSearchResults_Protocol: class {
    var delegate: AddressSearchResultsDelegate? { get set }
    var results: [SmartyStreetsAutocompleteSuggestion] { get }
    
    func updateSearchResults(for searchText: String?)
}

class AddressSearchResults: AddressSearchResults_Protocol {
    private let smartyStreetsService: SmartyStreetsService
    private(set) var results = [SmartyStreetsAutocompleteSuggestion]() {
        didSet {
            delegate?.addressSearchResults(self, didUpdateResults: results)
        }
    }
    private var timer: Timer?
    private let minimumSearchTermLengthBeforeSearching = 3
    private let searchCoalescingDelay = TimeInterval(1.0)
    private var searchText = ""

    weak var delegate: AddressSearchResultsDelegate?
    
    init(smartyStreetsService: SmartyStreetsService) {
        self.smartyStreetsService = smartyStreetsService
    }
    
    deinit {
        cancelAPITimer()
    }

    func updateSearchResults(for searchText: String?) {
        self.searchText = searchText ?? ""
        scheduleAPITimer()
    }
    
    private func performSearch() {
        guard searchText.count > minimumSearchTermLengthBeforeSearching else {
            results = []
            return
        }
        
        _ = smartyStreetsService.search(query: searchText)
            .done { locations in
                self.results = locations
            }.catch { _ -> Void in
                self.results = []
        }
    }
    
    private func scheduleAPITimer() {
        if let timer = timer {
            timer.fireDate = Date(timeIntervalSinceNow: searchCoalescingDelay)
        } else {
            self.timer = Timer.scheduledTimer(withTimeInterval: searchCoalescingDelay, repeats: false) { [weak self] _ in
                self?.timer = nil
                self?.performSearch()
            }
        }
    }
    
    private func cancelAPITimer() {
        timer?.invalidate()
        timer = nil
    }
}
