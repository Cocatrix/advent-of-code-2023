/// The interesting file is this one
import Foundation

resolvePartOne(Launcher.puzzleInput)

func resolvePartOne(_ input: [String]) {
    
    let result = input
        .map { line in
            let (winning, choices) = parse(line: line)
            let nb = numberOfWins(winning: winning, choices: choices)
            return twoPower(n: nb)
        }
        .reduce(0, { $0 + $1 })
    
    D.log(D.solution, newlines: true)
    print(result)
}

func resolvePartTwo(_ input: [String]) {
    
    // TODO: Solve
    
    D.log(D.solution, newlines: true)
    print()
}

func parse(line: String) -> (winning: [Int], choices: [Int]) {
    let card = line.split(separator: ":").map { String($0) }[1]
    let bothParts = card.split(separator: "|").map { String($0) }
    return (bothParts[0].parsingInts, bothParts[1].parsingInts)
}

func numberOfWins(winning: [Int], choices: [Int]) -> Int {
    return winning.filter { choices.contains($0) }.count
}

func twoPower(n: Int) -> Int {
    D.log(n)
    if n == 0 { return 0 }
    return Int(pow(2.0, Double(n-1)))
}
