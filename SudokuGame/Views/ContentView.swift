import SwiftUI

struct ContentView: View {
    @StateObject private var game = SudokuGameViewModel()
    @State private var showingNewGame = false
    @State private var showingCompletion = false

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.97, blue: 0.99)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                header
                statusBar
                SudokuBoardView(game: game)
                    .aspectRatio(1, contentMode: .fit)
                actionBar
                NumberPadView(game: game)
                Spacer(minLength: 4)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
        }
        .confirmationDialog("Choose difficulty", isPresented: $showingNewGame) {
            ForEach(Difficulty.allCases) { difficulty in
                Button(difficulty.rawValue) {
                    game.startNewGame(difficulty: difficulty)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .onChange(of: game.isComplete) { completed in
            showingCompletion = completed
        }
        .alert("Puzzle complete!", isPresented: $showingCompletion) {
            Button("New Game") { showingNewGame = true }
            Button("Keep Looking", role: .cancel) { }
        } message: {
            Text("Solved in \(game.formattedTime) with \(game.mistakes) mistake\(game.mistakes == 1 ? "" : "s").")
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Sudoku")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.indigo)
                Text(game.difficulty.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                showingNewGame = true
            } label: {
                Label("New", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
        }
    }

    private var statusBar: some View {
        HStack {
            Label(game.formattedTime, systemImage: "clock")
            Spacer()
            Label("\(game.mistakes) mistakes", systemImage: "exclamationmark.triangle")
        }
        .font(.subheadline.monospacedDigit().weight(.medium))
        .foregroundStyle(.secondary)
    }

    private var actionBar: some View {
        HStack(spacing: 12) {
            ActionButton(title: "Erase", icon: "eraser", action: game.erase)
            ActionButton(
                title: "Notes",
                icon: game.notesMode ? "pencil.circle.fill" : "pencil.circle",
                active: game.notesMode
            ) { game.notesMode.toggle() }
            ActionButton(title: "Hint", icon: "lightbulb", action: game.useHint)
        }
    }
}

private struct ActionButton: View {
    let title: String
    let icon: String
    var active = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon).font(.title2)
                Text(title).font(.caption.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .foregroundStyle(active ? .white : Color.indigo)
            .background(active ? Color.indigo : Color.white, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
