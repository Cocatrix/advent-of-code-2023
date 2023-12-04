/// The interesting file is this one
import Foundation

resolvePartTwo(Launcher.puzzleInput)

func resolvePartOne(_ input: [String]) {
    
    let result = input
        .map { parse(line: $0) }
        .filter { !$0.reveals.contains(where: { isAboveThreshold(reveal: $0) }) }
        .reduce(0, { $0 + $1.game })
    
    D.log(D.solution, newlines: true)
    print(result)
}

func resolvePartTwo(_ input: [String]) {
    
    let result = input
        .map { parse(line: $0) }
        .map { mapToMinimumReveal(reveals: $0.reveals) }
        .reduce(0, { $0 + power(of: $1) })
    
    D.log(D.solution, newlines: true)
    print(result)
}

typealias Reveal = (red: Int, green: Int, blue: Int)

func parse(line: String) -> (game: Int, reveals: [Reveal]) {
    // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    let gameAndSubsets = line.split(separator: ":").map { String($0) }
    let game: Int = gameAndSubsets[0].parsingStringAndInt.1
    let reveals = parseResults(from: gameAndSubsets[1])
    return (game, reveals)
}

func parseResults(from subsets: String) -> [Reveal] {
    let sets = subsets.split(separator: ";").map { String($0) }
    return sets.map { parseColors(from: $0) }
}

func parseColors(from set: String) -> Reveal {
    let colors = set.split(separator: ",").map { String($0) }
    var reveal: Reveal = (0, 0, 0)
    colors.forEach { color in
        let (nb, rgb) = color.parsingIntAndString
        switch rgb {
            case "red":
                reveal = (nb, reveal.green, reveal.blue)
            case "green":
                reveal = (reveal.red, nb, reveal.blue)
            case "blue":
                reveal = (reveal.red, reveal.green, nb)
            default:
                fatalError()
        }
    }
    return reveal
}

func isAboveThreshold(reveal: Reveal) -> Bool {
    return reveal.red > 12 || reveal.green > 13 || reveal.blue > 14
}

func mapToMinimumReveal(reveals: [Reveal]) -> Reveal {
    var minimum: Reveal = (0, 0, 0)
    reveals.forEach { reveal in
        if reveal.red > minimum.red {
            minimum.red = reveal.red
        }
        if reveal.green > minimum.green {
            minimum.green = reveal.green
        }
        if reveal.blue > minimum.blue {
            minimum.blue = reveal.blue
        }
    }
    return minimum
}

func power(of reveal: Reveal) -> Int {
    return reveal.red * reveal.green * reveal.blue
}
