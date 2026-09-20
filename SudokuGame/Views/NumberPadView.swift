import SwiftUI

struct NumberPadView: View {
    @ObservedObject var game: SudokuGameViewModel

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...9, id: \.self) { number in
                Button {
                    game.enter(number)
                } label: {
                    Text("\(number)")
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .foregroundStyle(Color.indigo)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}
