/// The interesting file is this one
import Foundation

resolvePartTwo(Launcher.puzzleInput)

func resolvePartOne(_ input: [String]) {
    let result = input.reduce(0, { $0 + addFirstAndLastNumber(of: $1) })

    D.log(D.solution, newlines: true)
    print(result)
}

func resolvePartTwo(_ input: [String]) {
    let result = input.reduce(0, { $0 + getResult(of: $1) })

    D.log(D.solution, newlines: true)
    print(result)
}

// MARK: Part two

func getResult(of line: String) -> Int {
    let first: Int = getFirstRealOrWrittenNumber(of: line, reversed: false)
    let last: Int = getFirstRealOrWrittenNumber(of: String(line.reversed()), reversed: true)
    let result = 10 * first + last
    D.log(result)
    return result
}

func getFirstRealOrWrittenNumber(of line: String, reversed: Bool) -> Int {
    let (realValue, realOffset) = getFirstRealNumberBound(of: line)
    let (writtenValue, writtenOffset) = getFirstWrittenNumberBound(of: line, reversed: reversed)
    
    switch (realValue, writtenValue) {
        case (-1, _): return writtenValue
        case (_, -1): return realValue
        default: return realOffset <= writtenOffset ? realValue : writtenValue
    }
}

enum DigitsCharacters: String, CaseIterable {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    
    var intValue: Int {
        switch self {
            case .zero:
                0
            case .one:
                1
            case .two:
                2
            case .three:
                3
            case .four:
                4
            case .five:
                5
            case .six:
                6
            case .seven:
                7
            case .eight:
                8
            case .nine:
                9
        }
    }
}

func getFirstWrittenNumberBound(of line: String, reversed: Bool) -> (value: Int, offset: Int) {
    var lowerBound: String.Index = String.Index(utf16Offset: line.count-1, in: line)
    var firstNumber: Int = -1
    var range: Range<String.Index>?
    for digit in DigitsCharacters.allCases {
        let digitString = reversed ? String(digit.rawValue.reversed()) : digit.rawValue
        range = line.range(of: digitString)
        if let r = range, r.lowerBound < lowerBound {
            lowerBound = r.lowerBound
            firstNumber = digit.intValue
        }
    }
    let offset = lowerBound.utf16Offset(in: line)
    return (firstNumber, offset)
}

func getFirstRealNumberBound(of line: String) -> (value: Int, offset: Int) {
    guard let firstNumber: Int = getFirstNumber(of: line) else {
        return (-1, -1)
    }
    let lowerBound = line.range(of: "\(firstNumber)")!.lowerBound
    let offset = lowerBound.utf16Offset(in: line)
    return (firstNumber, offset)
}

// MARK: Part one

func getFirstNumber(of line: String) -> Int? {
    return line.first(where: { $0.isNumber })?.asInt
}

func getLastNumber(of line: String) -> Int? {
    return line.last(where: { $0.isNumber })?.asInt
}

func addFirstAndLastNumber(of line: String) -> Int {
    let first: Int = getFirstNumber(of: line) ?? 0
    let last: Int = getLastNumber(of: line) ?? 0
    let result = 10 * first + last
    D.log(result)
    return result
}

extension Character {
    var asInt: Int {
        return Int(String(self)) ?? 0
    }
}
