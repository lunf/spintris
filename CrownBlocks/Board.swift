import Foundation

struct Board: Equatable {
    static let width = 10
    static let height = 20

    private(set) var cells: [Tetromino?]

    init(cells: [Tetromino?] = Array(repeating: nil, count: Board.width * Board.height)) {
        precondition(cells.count == Board.width * Board.height)
        self.cells = cells
    }

    subscript(x: Int, y: Int) -> Tetromino? {
        get {
            guard contains(x: x, y: y) else { return nil }
            return cells[index(x: x, y: y)]
        }
        set {
            guard contains(x: x, y: y) else { return }
            cells[index(x: x, y: y)] = newValue
        }
    }

    func contains(x: Int, y: Int) -> Bool {
        x >= 0 && x < Board.width && y >= 0 && y < Board.height
    }

    func collides(with piece: Piece) -> Bool {
        piece.blocks.contains { point in
            point.x < 0
                || point.x >= Board.width
                || point.y >= Board.height
                || (point.y >= 0 && self[point.x, point.y] != nil)
        }
    }

    mutating func lock(_ piece: Piece) {
        for point in piece.blocks where contains(x: point.x, y: point.y) {
            self[point.x, point.y] = piece.tetromino
        }
    }

    mutating func clearCompletedLines() -> Int {
        var keptRows: [[Tetromino?]] = []
        var cleared = 0

        for y in 0..<Board.height {
            let row = (0..<Board.width).map { x in self[x, y] }
            if row.allSatisfy({ $0 != nil }) {
                cleared += 1
            } else {
                keptRows.append(row)
            }
        }

        let emptyRow = Array<Tetromino?>(repeating: nil, count: Board.width)
        let newRows = Array(repeating: emptyRow, count: cleared) + keptRows
        cells = newRows.flatMap { $0 }

        return cleared
    }

    private func index(x: Int, y: Int) -> Int {
        y * Board.width + x
    }
}
