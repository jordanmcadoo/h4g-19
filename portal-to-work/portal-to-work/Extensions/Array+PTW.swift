import Foundation

extension Array {
    func at(_ index: Int) -> Element? {
        guard index < count && index >= 0 else { return nil }
        return self[index]
    }
}
