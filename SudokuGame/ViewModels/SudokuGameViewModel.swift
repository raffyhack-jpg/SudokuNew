import Foundation
import Combine

@MainActor
final class SudokuGameViewModel: ObservableObject {
    @Published private(set) var values = Array(repeating: 0, count: 81)
    @Published private(set) var notes = Array(repeating: Set<Int>(), count: 81)
    @Published private(set) var givens = Set<Int>()
    @Published var selectedIndex: Int?
    @Published var notesMode = false
    @Published private(set) var mistakes = 0
    @Published private(set) var elapsedSeconds = 0
    @Published private(set) var isComplete = false
    @Published private(set) var difficulty: Difficulty = .easy

    private var solution = Array(repeating: 0, count: 81)
    private var timer: AnyCancellable?

    init() {
        startNewGame(difficulty: .easy)
    }

    func startNewGame(difficulty: Difficulty) {
        let puzzle = PuzzleLibrary.puzzle(for: difficulty)
        self.difficulty = difficulty
        values = puzzle.puzzle
        solution = puzzle.solution
        givens = Set(values.indices.filter { values[$0] != 0 })
        notes = Array(repeating: Set<Int>(), count: 81)
        selectedIndex = nil
        notesMode = false
        mistakes = 0
        elapsedSeconds = 0
        isComplete = false
        startTimer()
    }

    func select(_ index: Int) {
        selectedIndex = index
    }

    func enter(_ number: Int) {
        guard let index = selectedIndex, !givens.contains(index), !isComplete else { return }

        if notesMode {
            if notes[index].contains(number) {
                notes[index].remove(number)
            } else {
                notes[index].insert(number)
            }
            return
        }

        values[index] = number
        notes[index].removeAll()
        if number != solution[index] {
            mistakes += 1
        } else {
            removeNote(number, relatedTo: index)
        }
        checkCompletion()
    }

    func erase() {
        guard let index = selectedIndex, !givens.contains(index), !isComplete else { return }
        values[index] = 0
        notes[index].removeAll()
    }

    func useHint() {
        guard !isComplete else { return }
        let target = selectedIndex.flatMap { values[$0] == 0 ? $0 : nil }
            ?? values.indices.first(where: { values[$0] == 0 })
        guard let index = target else { return }
        values[index] = solution[index]
        notes[index].removeAll()
        selectedIndex = index
        removeNote(solution[index], relatedTo: index)
        checkCompletion()
    }

    func isWrong(_ index: Int) -> Bool {
        values[index] != 0 && values[index] != solution[index]
    }

    func isPeer(_ index: Int) -> Bool {
        guard let selectedIndex else { return false }
        return row(index) == row(selectedIndex)
            || column(index) == column(selectedIndex)
            || box(index) == box(selectedIndex)
    }

    func hasMatchingValue(_ index: Int) -> Bool {
        guard let selectedIndex, values[selectedIndex] != 0 else { return false }
        return values[index] == values[selectedIndex]
    }

    var formattedTime: String {
        String(format: "%02d:%02d", elapsedSeconds / 60, elapsedSeconds % 60)
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, !self.isComplete else { return }
                self.elapsedSeconds += 1
            }
    }

    private func checkCompletion() {
        if values == solution {
            isComplete = true
            timer?.cancel()
        }
    }

    private func removeNote(_ number: Int, relatedTo index: Int) {
        for candidate in values.indices where candidate != index {
            if row(candidate) == row(index)
                || column(candidate) == column(index)
                || box(candidate) == box(index) {
                notes[candidate].remove(number)
            }
        }
    }

    private func row(_ index: Int) -> Int { index / 9 }
    private func column(_ index: Int) -> Int { index % 9 }
    private func box(_ index: Int) -> Int { (row(index) / 3) * 3 + column(index) / 3 }
}
