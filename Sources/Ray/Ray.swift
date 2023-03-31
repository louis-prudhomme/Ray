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

// MARK: - Public types

public struct Iban: Equatable {
    public let underlying: String

    public init(from source: String) {
        underlying = source
    }

    public func clean() -> String {
        IbanValidator.clean(iban: underlying)
    }

    public var isValid: Bool {
        invalidityReasons.count == 0
    }

    public var invalidityReasons: [IbanViolation] {
        IbanValidator.validate(for: underlying)
    }

    public var country: SupportedCountry? {
        if let countryCode = underlying.countryCode, let country = SupportedCountry(rawValue: countryCode) {
            return country
        }
        return nil
    }

    public func formatted() -> String? {
        guard let formattingMask = country?.expectedIbanFormat else {
            return nil
        }

        var passedSpaces = 0
        var formatted: String = .empty
        for (index, char) in underlying.enumerated() {
            let offset = index + passedSpaces
            let mask = formattingMask[formattingMask.index(formattingMask.startIndex, offsetBy: offset)]
            if mask == " " {
                passedSpaces += 1
                formatted.append(" ")
            }

            formatted.append(char)
        }
        return formatted
    }
}

public enum IbanViolation: Error, Equatable {
    case invalidChecksum
    case unknownCountryCode(was: String)
    case exceedsMaximumLength(was: Int)
    case exceedsCountryLengthSpecification(expected: Int, got: Int)
    case containsForbiddenCharacters(saw: String)

    static let MAX_IBAN_LENGTH = 34
}

public enum SupportedCountry: String, CaseIterable {
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
    case SC
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
        case .SC: return 31
        case .CH: return 21
        case .TN: return 24
        case .TR: return 26
        case .AE: return 23
        case .GB: return 22
        case .VG: return 24
        }
    }
}

extension SupportedCountry {
    private static let IBAN_MASK_CHARACTER: Character = "*"
    var expectedIbanFormat: String {
        switch self {
        case .AL: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .AD: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .AT: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .AZ: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .BH: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .BY: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .BE: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .BA: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .BR: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .BG: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .CR: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .HR: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .CY: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .CZ: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .DK: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .DO: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .TL: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .EE: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .FO: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .FI: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .FR: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .GE: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .DE: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .GI: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .GR: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .GL: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .GT: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .HU: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .IS: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .IE: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .IL: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .IT: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .JO: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .KZ: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .XK: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .KW: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .LV: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .LB: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .LI: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .LT: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .LU: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .MK: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .MT: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .MR: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .MU: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .MC: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .MD: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .ME: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .NL: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .NO: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .PK: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .PS: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .PL: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .PT: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .QA: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .RO: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .SM: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .SA: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .RS: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .SK: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .SI: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .ES: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .SE: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .SC: return "**** **** ** ** **** **** **** **** ***"
        case .CH: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .TN: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .TR: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .AE: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .GB: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
        case .VG: return String(repeating: Self.IBAN_MASK_CHARACTER, count: expectedIbanLength)
            .inserting(separator: " ", every: 4)
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

    public static func validate(for iban: Iban) -> [IbanViolation] {
        validate(for: iban.underlying)
    }

    public static func validate(for iban: String) -> [IbanViolation] {
        let cleanIban = clean(iban: iban)

        return Self.rules.compactMap { $0(cleanIban) }
    }

    public static func validateOrThrow(for iban: Iban) throws {
        try validateOrThrow(for: iban.underlying)
    }

    public static func validateOrThrow(for iban: String) throws {
        let violations = Self.validate(for: iban)

        guard violations.count == 0 else {
            throw IbanValidatorError(violations: violations)
        }
    }

    static func clean(iban: String) -> String {
        String(iban.unicodeScalars.filter(CharacterSet.nonWhitespace.contains)).uppercased()
    }
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

// MARK: - String helpers

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

    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        .init(unfoldSubSequences(limitedTo: n).joined(separator: separator))
    }
}

extension Collection {
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence, Index> {
        sequence(state: startIndex) { start in
            guard start < endIndex else { return nil }
            let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start ..< end]
        }
    }

    func every(n: Int) -> UnfoldSequence<Element, Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { let _ = formIndex(&index, offsetBy: n, limitedBy: endIndex) }
            return self[index]
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

    private static let letters: [Character: Int] = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
                                                    "A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15, "G": 16, "H": 17, "I": 18,
                                                    "J": 19, "K": 20, "L": 21, "M": 22, "N": 23, "O": 24, "P": 25, "Q": 26, "R": 27,
                                                    "S": 28, "T": 29, "U": 30, "V": 31, "W": 32, "X": 33, "Y": 34, "Z": 35]

    private static func replaceAlphaChars(in string: String) throws -> String {
        struct NotFound: Error {}

        return try string
            .map { letters[$0] }
            .map { if let charValue = $0 { return "\(charValue)" } else { throw NotFound() } }
            .reduce(into: .empty) { $0.append($1) }
    }
}
