import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }
}

struct SudokuPuzzle {
    let puzzle: [Int]
    let solution: [Int]

    init(puzzle: String, solution: String) {
        self.puzzle = puzzle.compactMap { $0.wholeNumberValue }
        self.solution = solution.compactMap { $0.wholeNumberValue }
        precondition(self.puzzle.count == 81 && self.solution.count == 81)
    }
}

enum PuzzleLibrary {
    static func puzzle(for difficulty: Difficulty) -> SudokuPuzzle {
        switch difficulty {
        case .easy:
            return SudokuPuzzle(
                puzzle: "530070000600195000098000060800060003400803001700020006060000280000419005000080079",
                solution: "534678912672195348198342567859761423426853791713924856961537284287419635345286179"
            )
        case .medium:
            return SudokuPuzzle(
                puzzle: "000260701680070090190004500820100040004602900050003028009300074040050036703018000",
                solution: "435269781682571493197834562826195347374682915951743628519326874248957136763418259"
            )
        case .hard:
            return SudokuPuzzle(
                puzzle: "000000907000420180000705026100904000050000040000507009920108000034059000507000000",
                solution: "462831957795426183381795426173984265659312748248567319926178534834259671517643892"
            )
        }
    }
}
