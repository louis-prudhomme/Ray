# Ray (Iban)

Being a small Swift library to check the validity of IBAN codes. It's based on the the ISO 13616:2007 standard, which defines a checksum process described [here](https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN).

## Installation

*SPM:*

1. Add `.package(url: "https://github.com/louis-prudhomme/Ray.git"),` to your `Package.swift`
2. Run `swift package update`
3. That should be it.

*Carthage:*

Not yet. Maybe one day. You may want to fall back to the original library this repository is a fork of: [timd/IBANValidator](https://github.com/timd/IBANValidator).

## Usage

1. Import the framework wherever you want to use it: `import Ray`
2. Test the IBAN as such:

```swift
let validIbanNumber = Iban(from: "AL90208110080000001039531801")
let invalidIbanNumber = Iban(from: "dqzdqpzodzkqpdozqdu_ehçàçéi")
let anotherInvalidIbanNumber = Iban(from: "AL90208110080000001039531801921902118972918273")

print("\(validIbanNumber.isValid)") // true
print("\(invalidIbanNumber.isValid)") // false
print("\(anotherInvalidIbanNumber.isValid)") // false

// OR

do {
    IbanValidator.validateOrThrow(for: "FR7710293109283091830989776654")
} catch {
    (error as? IbanValidatorError)?.violations.map { print("Iban invalid because \($0)")}
}
```

## Validation errors

Errors are returned as an `IbanValidatorError`. It bears all the violations of the IBAN which allow you to provide feedback to your users.

- `invalidChecksum`: IBAN has an invalid checksum.
- `unknownCountryCode`: could not parse the country code (first two letters)
- `exceedsMaximumLength`: IBAN is over 34 characters
- `exceedsCountryLengthSpecification`: IBAN exceeds what length is specified for the country
- `containsForbiddenCharacters`: IBAN contains forbidden characters. Essentially, any non-alphanumeric character.

# Helpers

## Country codes

As a convenience for populating things like picker lists, `Ray` exposes the `SupportedCountry` `enum`. It is `CaseIterable` in order to build picker lists.

## Formatting

Use the `Iban#formatted` method to format your IBAN. Formatting depends on the country code of your IBAN.

## Acknowledgements

- This library uses [BigInt](https://github.com/attaswift/BigInt), as validating an IBAN requires computing the mod(97) of 34-digit integers.
- This library is based off [timd/IBANValidator](https://github.com/timd/IBANValidator) ; many thanks for their excellent work !

## Disclaimer

This library should only be used to check for an IBAN base conformity. It *must not* be the only check your program performs on user-given IBANs, but rather a passage before tapping onto [IBAN.com](https://www.iban.com/iban-suite) validator. 

Use at your own risk.
