import Combine
import Foundation

protocol GameFeedbackProviding: AnyObject {
    func pieceLocked()
    func linesCleared()
    func gameOver()
}

final class GameEngine: ObservableObject {
    @Published private(set) var board = Board()
    @Published private(set) var activePiece: Piece?
    @Published private(set) var nextTetromino: Tetromino = .t
    @Published private(set) var scoreManager = ScoreManager()
    @Published private(set) var isGameOver = false

    private let feedback: GameFeedbackProviding?
    private var lastFallDate: Date?
    private var pieceBag: [Tetromino] = []

    init(feedback: GameFeedbackProviding? = nil) {
        self.feedback = feedback
        restart()
    }

    func restart() {
        board = Board()
        scoreManager.reset()
        isGameOver = false
        lastFallDate = nil
        pieceBag = []
        nextTetromino = drawTetromino()
        spawnPiece()
    }

    func tick(now: Date) {
        guard !isGameOver else { return }

        if lastFallDate == nil {
            lastFallDate = now
            return
        }

        guard let lastFallDate, now.timeIntervalSince(lastFallDate) >= scoreManager.dropInterval else {
            return
        }

        self.lastFallDate = now
        moveDownOrLock()
    }

    func moveLeft() {
        attemptMove(x: -1, y: 0)
    }

    func moveRight() {
        attemptMove(x: 1, y: 0)
    }

    func rotateActivePiece() {
        guard let activePiece, !isGameOver else { return }

        let rotated = activePiece.rotatedClockwise()
        if !board.collides(with: rotated) {
            self.activePiece = rotated
            return
        }

        for kick in [-1, 1, -2, 2] {
            let kicked = rotated.movedBy(x: kick, y: 0)
            if !board.collides(with: kicked) {
                self.activePiece = kicked
                return
            }
        }
    }

    func hardDrop() {
        guard var fallingPiece = activePiece, !isGameOver else { return }

        while !board.collides(with: fallingPiece.movedBy(x: 0, y: 1)) {
            fallingPiece = fallingPiece.movedBy(x: 0, y: 1)
        }

        activePiece = fallingPiece
        lockActivePiece()
    }

    private func attemptMove(x: Int, y: Int) {
        guard let activePiece, !isGameOver else { return }
        let moved = activePiece.movedBy(x: x, y: y)
        if !board.collides(with: moved) {
            self.activePiece = moved
        }
    }

    private func moveDownOrLock() {
        guard let activePiece else { return }
        let moved = activePiece.movedBy(x: 0, y: 1)

        if board.collides(with: moved) {
            lockActivePiece()
        } else {
            self.activePiece = moved
        }
    }

    private func lockActivePiece() {
        guard let activePiece else { return }

        board.lock(activePiece)
        feedback?.pieceLocked()

        let clearedLines = board.clearCompletedLines()
        if clearedLines > 0 {
            scoreManager.addClearedLines(clearedLines)
            feedback?.linesCleared()
        }

        spawnPiece()
    }

    private func spawnPiece() {
        let piece = Piece(
            tetromino: nextTetromino,
            origin: BoardPoint(x: 3, y: 0)
        )

        if board.collides(with: piece) {
            activePiece = nil
            isGameOver = true
            feedback?.gameOver()
        } else {
            activePiece = piece
            nextTetromino = drawTetromino()
        }
    }

    private func drawTetromino() -> Tetromino {
        if pieceBag.isEmpty {
            pieceBag = Tetromino.allCases.shuffled()
        }

        return pieceBag.removeLast()
    }
}
