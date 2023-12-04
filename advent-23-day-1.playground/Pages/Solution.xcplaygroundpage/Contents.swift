/// The interesting file is this one
import Foundation

resolvePartOne(Launcher.puzzleInput)

func resolvePartOne(_ input: [String]) {
    let result = input.reduce(0, { $0 + addFirstAndLastNumber(of: $1) })

    D.log(D.solution, newlines: true)
    print(result)
}

func resolvePartTwo(_ input: [String]) {
    
    // TODO: Solve
    
    D.log(D.solution, newlines: true)
    print()
}

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
