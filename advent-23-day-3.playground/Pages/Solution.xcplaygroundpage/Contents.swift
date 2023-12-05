/// The interesting file is this one
import Foundation

resolvePartOne(Launcher.puzzleInput)

func resolvePartOne(_ input: [String]) {
    
    let result = giveValidNumberSum(lines: input)
    
    D.log(D.solution, newlines: true)
    print(result)
}

func resolvePartTwo(_ input: [String]) {
    
    // TODO: Solve
    
    D.log(D.solution, newlines: true)
    print()
}

enum EnginePart {
    case number(Int, Int, Int, Int) // x, y, value, nbDigits
    case symbol(Int, Int) // x, y
}

extension EnginePart: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
            case .number(let x, let y, let value, let nbDigits):
                return "\(value)(\(x), \(y))"
            case .symbol(let xS, let yS):
                return "$(\(xS), \(yS))"
        }
    }
}

func parse(line: String, lineNumber: Int) -> [EnginePart] {
    var arrayLine = Array(line)
    var lastPart: Int = 0
    var nbDigits: Int = 0
    var result: [EnginePart] = []
    for i in 0..<line.count {
        switch String(arrayLine[i]) {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                lastPart = lastPart * 10 + Int(String(arrayLine[i]))!
                nbDigits += 1
            default:
                if lastPart > 0 {
                    result.append(EnginePart.number(lineNumber, i-1, lastPart, nbDigits))
                }
                lastPart = 0
                nbDigits = 0
                if String(arrayLine[i]) != "." {
                    result.append(EnginePart.symbol(lineNumber, i))
                }
        }
    }
    if lastPart > 0 {
        result.append(EnginePart.number(lineNumber, line.count-1, lastPart, nbDigits))
    }
    return result
}

func filterNumbersWithNeighborSymbols(from parts: [EnginePart], nbLines: Int) -> [EnginePart] {
    return parts.filter {
        switch $0 {
            case .number(let x, let y, _, let nbDigits):
                
                let hasNeighbor = parts.contains(where: { part in
                    switch part {
                        case .symbol(let xS, let yS):
                            return isNeighbor(x, y, xS, yS, nbDigits)
                        default:
                            return false
                    }
                })
                return hasNeighbor
            default:
                return false
        }
    }
}

func isNeighbor(_ x: Int, _ y: Int, _ xS: Int, _ yS: Int, _ nbDigits: Int) -> Bool {
    guard xS-1 <= x, x <= xS+1 else {
        return false
    }
    for i in -1...nbDigits {
        if (y-i) == yS {
            return true
        }
    }
    return false
}

func sum(parts: [EnginePart]) -> Int {
    let result = parts.reduce(0, { (accu, part) in
        switch part {
            case .number(_, _, let numberValue, _):
                return accu + numberValue
            default:
                return accu
        }
    })
    return result
}

func giveValidNumberSum(lines: [String]) -> Int {
    var engineParts: [EnginePart] = []
    for (index, line) in lines.enumerated() {
        engineParts.append(contentsOf: parse(line: line, lineNumber: index))
    }
    let validNumbers = filterNumbersWithNeighborSymbols(from: engineParts, nbLines: lines.count)
    return sum(parts: validNumbers)
}
