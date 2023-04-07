import XCTest

@testable import Ray

final class RayTests: XCTestCase {
    // Test IBANs generated by https://www.generateiban.com/test-iban/

    func test_countryShouldBeNil_forEmptyIban() {
        let ibanUnderTest = ""

        XCTAssertTrue(Iban(from: ibanUnderTest).country == nil)
    }
    
    func test_shouldBeInvalid_forEmptyIban() {
        let ibanUnderTest = ""

        XCTAssertTrue(Iban(from: ibanUnderTest).isValid == false)
    }
    
    func test_shouldThrow_WhenInvalidChecksum() {
        let ibanUnderTest = "FR2830003000309332627391239"

        let expected: [IbanViolation] = [.invalidChecksum]
        let actual: [IbanViolation] = IbanValidator.validate(for: ibanUnderTest)

        expected.forEach { XCTAssertTrue(actual.contains($0)) }
        actual.forEach { XCTAssertTrue(expected.contains($0)) }
    }
    
    func test_shouldThrow_WhenInvalidChecksum2() {
        let ibanUnderTest = "GB55BUKB20201555555555"

        let expected: [IbanViolation] = [.invalidChecksum]
        let actual: [IbanViolation] = IbanValidator.validate(for: ibanUnderTest)

        expected.forEach { XCTAssertTrue(actual.contains($0)) }
        actual.forEach { XCTAssertTrue(expected.contains($0)) }
    }

    func test_shouldThrow_WhenInvalidCountryCode() {
        let ibanUnderTest = "ZZ1730003000309332627391239"

        let expected: [IbanViolation] = [.unknownCountryCode(was: "ZZ")]
        let actual: [IbanViolation] = IbanValidator.validate(for: ibanUnderTest)

        expected.forEach { XCTAssertTrue(actual.contains($0)) }
        actual.forEach { XCTAssertTrue(expected.contains($0)) }
    }

    func test_shouldThrow_WhenEmptyCountryCode() {
        let ibanUnderTest = ""

        let expected: [IbanViolation] = [.unknownCountryCode(was: "<nil>")]
        let actual: [IbanViolation] = IbanValidator.validate(for: ibanUnderTest)

        expected.forEach { XCTAssertTrue(actual.contains($0)) }
        actual.forEach { XCTAssertTrue(expected.contains($0)) }
    }

    func test_shouldThrow_WhenInvalidCountryLength() {
        let ibanUnderTest = "FR71300030003093326273912390"

        let expected: [IbanViolation] = [.exceedsCountryLengthSpecification(expected: 27, got: 28)]
        let actual: [IbanViolation] = IbanValidator.validate(for: ibanUnderTest)

        expected.forEach { XCTAssertTrue(actual.contains($0)) }
        actual.forEach { XCTAssertTrue(expected.contains($0)) }
    }

    func test_shouldThrow_WhenInvalidLength() {
        let ibanUnderTest = "FR813000300030933262739123871000000000000000"

        let expected: [IbanViolation] = [.exceedsMaximumLength(was: ibanUnderTest.count), .exceedsCountryLengthSpecification(expected: 27, got: ibanUnderTest.count)]
        let actual: [IbanViolation] = IbanValidator.validate(for: ibanUnderTest)

        expected.forEach { XCTAssertTrue(actual.contains($0)) }
        actual.forEach { XCTAssertTrue(expected.contains($0)) }
    }

    func test_shouldThrow_WhenInvalidCharacters() {
        let ibanUnderTest = "FR283000300030933262739123🐷"

        let expected: [IbanViolation] = [.containsForbiddenCharacters(saw: "🐷")]
        let actual: [IbanViolation] = IbanValidator.validate(for: ibanUnderTest)

        expected.forEach { XCTAssertTrue(actual.contains($0)) }
        actual.forEach { XCTAssertTrue(expected.contains($0)) }
    }

    func test_shouldNotThrow_ForAValidIban() {
        let ibanUnderTest = "FR2730003000309332627391239"

        let expected: [IbanViolation] = []
        let actual: [IbanViolation] = IbanValidator.validate(for: ibanUnderTest)

        expected.forEach { XCTAssertTrue(actual.contains($0)) }
        actual.forEach { XCTAssertTrue(expected.contains($0)) }
    }

    func test_shouldFormat_validIban() {
        let ibanUnderTest = "FR2730003000309332627391239"
        let expected = "FR27 3000 3000 3093 3262 7391 239"

        let actual = Iban(from: ibanUnderTest).formatted()

        XCTAssertEqual(expected, actual!)
    }
    
    func test_shouldFormat_tooLongIban() {
        let ibanUnderTest = "SC001111223344445555666677778889999"
        let expected = "SC00 1111 22 33 4444 5555 6666 7777 8889999"

        let actual = Iban(from: ibanUnderTest).formatted()

        XCTAssertEqual(expected, actual!)
    }
    
    func test_shouldFormat_seychellesIban() {
        let ibanUnderTest = "SC00111122334444555566667777888"
        let expected = "SC00 1111 22 33 4444 5555 6666 7777 888"

        let actual = Iban(from: ibanUnderTest).formatted()

        XCTAssertEqual(expected, actual!)
    }

    func test_shouldNotThrow_WhenTrueForValidIban() {
        // Test IBANs taken from https://www.iban-bic.com/sample_accounts.html

        let ibans = ["AL90208110080000001039531801",
                     "BE68844010370034",
                     "DK5750510001322617",
                     "DE12500105170648489890",
                     "EE342200221034126658",
                     "FI9814283500171141",
                     "FR7630066100410001057380116",
                     "GB32ESSE40486562136016",
                     "IE92BOFI90001710027952",
                     "IT68D0300203280000400162854",
                     "LI1008800000020176306",
                     "LU761111000872960000",
                     "MT98MMEB44093000000009027293051",
                     "MC1112739000700011111000H79",
                     "NL18ABNA0484869868",
                     "NO5015032080119",
                     "AT022050302101023600",
                     "PL37109024020000000610000434",
                     "PT50003506830000000784311",
                     "SM86U0322509800000000270100",
                     "SE6412000000012170145230",
                     "CH3908704016075473007",
                     "SK9311110000001057361004",
                     "SI56031001001300933",
                     "ES1020903200500041045040",
                     "CZ4201000000195505030267",
                     "HU29117080012054779400000000"]

        for iban in ibans {
            try! IbanValidator.validateOrThrow(for: iban)
        }
    }
}
