//
//  Ray.swift
//  Iban
//  IbanValidator
//  IbanValidatorError
//
//  Created by Tim Duckett on 29.10.17.
//  Copyright © 2023 Louis Prud'homme. All rights reserved.
//

import BigInt
import Foundation

public enum IbanViolation: Error, Equatable {
    case invalidChecksum
    case unknownCountryCode(was: String)
    case exceedsMaximumLength(was: Int)
    case exceedsCountryLengthSpecification(expected: Int, got: Int)
    case containsForbiddenCharacters(saw: String)

    static let MAX_IBAN_LENGTH = 34
}

public enum SupportedCountry: String {
    case AL
    case AD
    case AT
    case AZ
    case BH
    case BY
    case BE
    case BA
    case BR
    case BG
    case CR
    case HR
    case CY
    case CZ
    case DK
    case DO
    case TL
    case EE
    case FO
    case FI
    case FR
    case GE
    case DE
    case GI
    case GR
    case GL
    case GT
    case HU
    case IS
    case IE
    case IL
    case IT
    case JO
    case KZ
    case XK
    case KW
    case LV
    case LB
    case LI
    case LT
    case LU
    case MK
    case MT
    case MR
    case MU
    case MC
    case MD
    case ME
    case NL
    case NO
    case PK
    case PS
    case PL
    case PT
    case QA
    case RO
    case SM
    case SA
    case RS
    case SK
    case SI
    case ES
    case SE
    case CH
    case TN
    case TR
    case AE
    case GB
    case VG
}

extension SupportedCountry {
    var expectedIbanLength: Int {
        switch self {
        case .AL: return 28
        case .AD: return 24
        case .AT: return 20
        case .AZ: return 28
        case .BH: return 22
        case .BY: return 28
        case .BE: return 16
        case .BA: return 20
        case .BR: return 29
        case .BG: return 22
        case .CR: return 22
        case .HR: return 21
        case .CY: return 28
        case .CZ: return 24
        case .DK: return 18
        case .DO: return 28
        case .TL: return 23
        case .EE: return 20
        case .FO: return 18
        case .FI: return 18
        case .FR: return 27
        case .GE: return 22
        case .DE: return 22
        case .GI: return 23
        case .GR: return 27
        case .GL: return 18
        case .GT: return 28
        case .HU: return 28
        case .IS: return 26
        case .IE: return 22
        case .IL: return 23
        case .IT: return 27
        case .JO: return 30
        case .KZ: return 20
        case .XK: return 20
        case .KW: return 30
        case .LV: return 21
        case .LB: return 28
        case .LI: return 21
        case .LT: return 20
        case .LU: return 20
        case .MK: return 19
        case .MT: return 31
        case .MR: return 27
        case .MU: return 30
        case .MC: return 27
        case .MD: return 24
        case .ME: return 22
        case .NL: return 18
        case .NO: return 15
        case .PK: return 24
        case .PS: return 29
        case .PL: return 28
        case .PT: return 25
        case .QA: return 29
        case .RO: return 24
        case .SM: return 27
        case .SA: return 24
        case .RS: return 22
        case .SK: return 24
        case .SI: return 19
        case .ES: return 24
        case .SE: return 24
        case .CH: return 21
        case .TN: return 24
        case .TR: return 26
        case .AE: return 23
        case .GB: return 22
        case .VG: return 24
        }
    }
}

extension CharacterSet {
    static let ibanAuthorized: CharacterSet = .uppercaseLetters.union(.decimalDigits)
    static let ibanForbidden: CharacterSet = ibanAuthorized.inverted
    static let nonWhitespace: CharacterSet = whitespaces.inverted
}

public struct IbanValidatorError: Error {
    let violations: [IbanViolation]
}

typealias IbanRule = (_ iban: String) -> IbanViolation?
public struct IbanValidator {
    static let rules: [IbanRule] = [isIbanComposedOfAllowedCharactersOnly,
                                    doesIbanHaveValidCountryCode,
                                    doesIbanExceedCountryLengthSpecification,
                                    doesIbanExceedMaximumLength,
                                    hasValidChecksum]

    private init() {}

    public static func validate(for iban: String) -> [IbanViolation] {
        let cleanIban = clean(iban: iban)

        return Self.rules.compactMap { $0(cleanIban) }
    }

    public static func validateOrThrow(for iban: String) throws {
        let violations = Self.validate(for: iban)

        guard violations.count == 0 else {
            throw IbanValidatorError(violations: violations)
        }
    }

    private static func clean(iban: String) -> String {
        String(iban.unicodeScalars.filter(CharacterSet.nonWhitespace.contains)).uppercased()
    }
}

// MARK: - Helpers

extension String {
    var countryCode: String? {
        if count < 2 { return nil }
        return String(prefix(2))
    }

    var checksum: String? {
        if count < 4 { return nil }
        return String(prefix(4).suffix(2))
    }

    static var empty: String { "" }
}

// MARK: - Rules

extension IbanValidator {
    private static func isIbanComposedOfAllowedCharactersOnly(within iban: String) -> IbanViolation? {
        let forbidden = String(iban.unicodeScalars.filter(CharacterSet.ibanForbidden.contains))
        if forbidden.count != 0 {
            return .containsForbiddenCharacters(saw: forbidden)
        }

        return nil
    }

    private static func doesIbanHaveValidCountryCode(iban: String) -> IbanViolation? {
        guard let countryCode = iban.countryCode else {
            return nil
        }
        return SupportedCountry(rawValue: countryCode) == nil
            ? .unknownCountryCode(was: iban.countryCode ?? "<nil>")
            : nil
    }

    private static func doesIbanExceedMaximumLength(iban: String) -> IbanViolation? {
        iban.count > IbanViolation.MAX_IBAN_LENGTH ? IbanViolation.exceedsMaximumLength(was: iban.count) : nil
    }

    private static func doesIbanExceedCountryLengthSpecification(for iban: String) -> IbanViolation? {
        if let country = iban.countryCode.flatMap({ SupportedCountry(rawValue: $0) }) {
            return country.expectedIbanLength != iban.count
                ? .exceedsCountryLengthSpecification(expected: country.expectedIbanLength, got: iban.count)
                : nil
        }
        return nil
    }

    private static func hasValidChecksum(for iban: String) -> IbanViolation? {
        let rearranged = rearrange(iban: iban)
        if let expunged = try? replaceAlphaChars(in: rearranged) {
            let checksum = BigInt(stringLiteral: expunged) % 97
            return checksum == 1 ? nil : .invalidChecksum
        } else {
            return nil
        }
    }
}

// MARK: - Checksum helpers

extension IbanValidator {
    private static func rearrange(iban: String) -> String {
        // Get first 4 chars
        let firstFourCharsIndex = iban.index(iban.startIndex, offsetBy: 4)
        let firstFourChars = String(iban[iban.startIndex ..< firstFourCharsIndex])

        // Get remaining chars
        let remainingChars = String(iban[firstFourCharsIndex...])

        return remainingChars + firstFourChars
    }

    private static func replaceAlphaChars(in string: String) throws -> String {
        struct NotFound: Error {}

        let letters: [Character: Int] = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
                                         "A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15, "G": 16, "H": 17, "I": 18,
                                         "J": 19, "K": 20, "L": 21, "M": 22, "N": 23, "O": 24, "P": 25, "Q": 26, "R": 27,
                                         "S": 28, "T": 29, "U": 30, "V": 31, "W": 32, "X": 33, "Y": 34, "Z": 35]

        return try string
            .map { letters[$0] }
            .map { if let charValue = $0 { return "\(charValue)" } else { throw NotFound() } }
            .reduce(into: .empty) { $0.append($1) }
    }
}
