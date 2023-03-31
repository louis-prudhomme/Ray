# Ray (Iban)

Being a small Swift library to check the validity of IBAN codes. It's based on the the ISO 13616:2007 standard, which defines a checksum process described [here](https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN).

## Installation

*SPM:*

1. Add `.package(url: "https://github.com/louis-prudhomme/Ray.git"),` to your `Package.swift`
2. Run `swift package update`
5. That should be it.

*Cocoapods:*

Not yet. Maybe one day.

## Usage

1. Import the framework wherever you want to use it: `import Ray`
2. Test the IBAN as such:

```swift
let validIBAN = "AL90208110080000001039531801"

do {
    
    // returns true for valid IBAN, false + error
    // if there's a problem
    let _ = try IBANValidator(iban: validIBAN)
    
    // Validation was successful, carry on
    
} catch let error as IBANValidationError {
    
    // Something is wrong with the IBAN, so handle the error
    print(error)
    
} catch {
    
    // Something else went wrong
    
}
```

## Validation errors

Errors are returned as an `IbanValidationError`:

```swift
public enum IBANValidationError: String, LocalizedError {
    case invalidChecksum = "Invalid checksum"
    case invalidCountryCode = "Invalid country code"
    case invalidLength = "Invalid length"
    case invalidCharacters = "Invalid characters"
}
```
* `invalidChecksum` is returned if the checksum calculation fails. This indicates an invalid IBAN.
* `invalidCountryCode` is returned if the country code does not appear on the list of supported countries (see the list at the top of `IBANValidator.swift` for the current list)
* `invalidLength` is returned if the provided IBAN is longer than 34 characters; or exceeds the length defined as the maximum for the country (these differ from country to country) 
* `invalidCharacters` is returned if the provided IBAN contains non-alphanumeric characters. The IBAN standard doesn't support Emoji yet.

## Country codes

As a convenience for populating things like picker lists, `IBANValidator` exposes the `countries` property which is an `Array` of `Dictionaries` containing a two-letter country code as the key. When sorted, this could be used as the data source for a picker to speed up the IBAN data entry and reduce use errors.

## Acknowledgements

This framework uses Marcel Kröker's [Swift-Big-Integer library](https://github.com/mkrd/Swift-Big-Integer), because calculating mod(97) of 34-digit integers makes my head hurt. Sample IBAN numbers for testing can be obtained [here](https://www.iban-bic.com/sample_accounts.html).

## Disclaimer

Use at your own risk. You probably don't want to rely on this library alone if you're doing anything as dramatic as transferring real money. But it's a good starting point...
