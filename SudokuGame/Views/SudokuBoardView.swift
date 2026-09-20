import SwiftUI

struct SudokuBoardView: View {
    @ObservedObject var game: SudokuGameViewModel

    var body: some View {
        GeometryReader { proxy in
            let cellSize = proxy.size.width / 9
            ZStack(alignment: .topLeading) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 9), spacing: 0) {
                    ForEach(0..<81, id: \.self) { index in
                        cell(index)
                            .frame(width: cellSize, height: cellSize)
                            .contentShape(Rectangle())
                            .onTapGesture { game.select(index) }
                    }
                }
                gridLines(size: proxy.size.width)
                    .allowsHitTesting(false)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.indigo, lineWidth: 2.5))
            .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        }
    }

    @ViewBuilder
    private func cell(_ index: Int) -> some View {
        ZStack {
            background(for: index)
            if game.values[index] != 0 {
                Text("\(game.values[index])")
                    .font(.system(size: 23, weight: game.givens.contains(index) ? .bold : .semibold, design: .rounded))
                    .foregroundStyle(numberColor(for: index))
            } else {
                NotesView(notes: game.notes[index])
            }
        }
    }

    private func background(for index: Int) -> Color {
        if game.selectedIndex == index { return Color.indigo.opacity(0.28) }
        if game.hasMatchingValue(index) { return Color.indigo.opacity(0.18) }
        if game.isPeer(index) { return Color.indigo.opacity(0.08) }
        return .white
    }

    private func numberColor(for index: Int) -> Color {
        if game.isWrong(index) { return .red }
        return game.givens.contains(index) ? Color.primary : Color.indigo
    }

    private func gridLines(size: CGFloat) -> some View {
        Canvas { context, canvasSize in
            for line in 1..<9 {
                let position = CGFloat(line) * size / 9
                var vertical = Path()
                vertical.move(to: CGPoint(x: position, y: 0))
                vertical.addLine(to: CGPoint(x: position, y: canvasSize.height))
                var horizontal = Path()
                horizontal.move(to: CGPoint(x: 0, y: position))
                horizontal.addLine(to: CGPoint(x: canvasSize.width, y: position))
                let width: CGFloat = line.isMultiple(of: 3) ? 2.2 : 0.55
                let color = line.isMultiple(of: 3) ? Color.indigo : Color.gray.opacity(0.55)
                context.stroke(vertical, with: .color(color), lineWidth: width)
                context.stroke(horizontal, with: .color(color), lineWidth: width)
            }
        }
    }
}

private struct NotesView: View {
    let notes: Set<Int>

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
            ForEach(1...9, id: \.self) { number in
                Text(notes.contains(number) ? "\(number)" : " ")
                    .font(.system(size: 8, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.indigo.opacity(0.85))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(2)
    }
}
