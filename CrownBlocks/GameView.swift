import SwiftUI

struct GameView: View {
    @StateObject private var engine = GameEngine(feedback: HapticsManager())
    @State private var crownValue = 0.0
    @State private var crownInput = CrownInputController(threshold: 0.9)

    private let loop = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            GameRenderer(board: engine.board, activePiece: engine.activePiece)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                HStack {
                    NextPiecePreview(tetromino: engine.nextTetromino)
                    Spacer()
                }
                Spacer()
            }
            .padding(.leading, 1)
            .allowsHitTesting(false)

            VStack {
                HStack {
                    Spacer()
                    scoreSidePanel
                }
                Spacer()
            }
            .padding(.trailing, 1)
            .allowsHitTesting(false)

            if engine.isGameOver {
                gameOverOverlay
            }
        }
        .padding(2)
        .background(Color.black)
        .contentShape(Rectangle())
        .gesture(playTapGesture)
        .focusable(true)
        .digitalCrownRotation(
            $crownValue,
            from: -10_000,
            through: 10_000,
            by: 0.1,
            sensitivity: .medium,
            isContinuous: true,
            isHapticFeedbackEnabled: false
        )
        .onChange(of: crownValue) { _, newValue in
            handleCrownChange(newValue)
        }
        .onReceive(loop) { now in
            engine.tick(now: now)
        }
    }

    private var playTapGesture: some Gesture {
        ExclusiveGesture(
            TapGesture(count: 2),
            TapGesture(count: 1)
        )
        .onEnded { value in
            switch value {
            case .first:
                if engine.isGameOver {
                    restartGame()
                } else {
                    engine.hardDrop()
                }
            case .second:
                if engine.isGameOver {
                    restartGame()
                } else {
                    engine.rotateActivePiece()
                }
            }
        }
    }

    private var scoreSidePanel: some View {
        VStack(alignment: .trailing, spacing: 3) {
            Text("\(engine.scoreManager.score)")
                .font(.system(.caption, design: .rounded).monospacedDigit())
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            HStack(spacing: 4) {
                Text("L\(engine.scoreManager.level)")
                    .font(.system(.caption2, design: .rounded).monospacedDigit())

                Text("\(engine.scoreManager.lines)")
                    .font(.system(.caption2, design: .rounded).monospacedDigit())
            }
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 5)
        .background(.black.opacity(0.56), in: RoundedRectangle(cornerRadius: 5))
    }

    private var gameOverOverlay: some View {
        VStack(spacing: 5) {
            Text("GAME OVER")
                .font(.system(.caption, design: .rounded).weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Text("Tap to restart")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.black.opacity(0.82), in: RoundedRectangle(cornerRadius: 6))
    }

    private func restartGame() {
        engine.restart()
        crownValue = 0
        crownInput.reset(to: 0)
    }

    private func handleCrownChange(_ newValue: Double) {
        guard let move = crownInput.move(for: newValue), !engine.isGameOver else { return }

        switch move {
        case .left:
            engine.moveLeft()
        case .right:
            engine.moveRight()
        }
    }
}
