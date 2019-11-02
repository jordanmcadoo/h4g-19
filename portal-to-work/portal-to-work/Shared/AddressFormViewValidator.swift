import Foundation

class AddressFormViewValidator {
    init() {}

    func validateRequiredFields(_ view: AddressForm) -> Address? {
        let isValidStreet = nonEmptyValidator(field: view.streetTextField)
        let isValidCity = nonEmptyValidator(field: view.cityTextField)
        let isValidState = stateValidator(field: view.stateTextField)
        let isValidPostalCode = postalCodeValidator(field: view.postalCodeTextField)
        
        let isValid = isValidStreet
            && isValidCity
            && isValidState
            && isValidPostalCode
        
        if isValid {
            return Address(street: view.streetTextField.trimmedTextValue, city: view.cityTextField.trimmedTextValue, state: view.stateTextField.trimmedTextValue, postalCode: view.postalCodeTextField.trimmedTextValue)
        } else {
            return nil
        }
    }
    
    private func nonEmptyValidator(field: PortalTextField) -> Bool {
        if field.trimmedTextValue.isEmpty {
            field.errorMessage = " "
            return false
        } else {
            field.errorMessage = nil
            return true
        }
    }
    
    private func stateValidator(field: PortalTextField) -> Bool {
        if field.trimmedTextValue.count != 2 {
            field.errorMessage = "2 letters only"
            return false
        } else {
            field.errorMessage = nil
            return true
        }
    }
    
    private func postalCodeValidator(field: PortalTextField) -> Bool {
        if validatePostCode(field.trimmedTextValue) {
            field.errorMessage = nil
            return true
        } else {
            field.errorMessage = "5 or 9 digits"
            return false
        }
    }
    
    private func validatePostCode(_ string: String) -> Bool {
        guard !string.isEmpty else {
            return false
        }
        
        let range = NSRange(string.startIndex..., in: string)
        let regex = try! NSRegularExpression(pattern: "^[0-9]{5}(?:(?:[ |-])?[0-9]{4})?$")
        let result = regex.firstMatch(in: string, options: [], range: range) != nil
        return result
    }
}
