import Foundation

struct Piece: Equatable {
    var tetromino: Tetromino
    var rotationIndex: Int
    var origin: BoardPoint

    init(tetromino: Tetromino, rotationIndex: Int = 0, origin: BoardPoint) {
        self.tetromino = tetromino
        self.rotationIndex = rotationIndex
        self.origin = origin
    }

    var blocks: [BoardPoint] {
        tetromino.rotations[rotationIndex].map {
            BoardPoint(x: origin.x + $0.x, y: origin.y + $0.y)
        }
    }

    func movedBy(x deltaX: Int, y deltaY: Int) -> Piece {
        var copy = self
        copy.origin = BoardPoint(x: origin.x + deltaX, y: origin.y + deltaY)
        return copy
    }

    func rotatedClockwise() -> Piece {
        var copy = self
        copy.rotationIndex = (rotationIndex + 1) % tetromino.rotations.count
        return copy
    }
}
