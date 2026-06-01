import SwiftUI

struct GameRenderer: View {
    let board: Board
    let activePiece: Piece?

    var body: some View {
        Canvas { context, size in
            let cellSize = CGSize(
                width: size.width / CGFloat(Board.width),
                height: size.height / CGFloat(Board.height)
            )
            
            let boardSize = CGSize(
                width: cellSize.width * CGFloat(Board.width),
                height: cellSize.height * CGFloat(Board.height)
            )
            let origin = CGPoint(
                x: (size.width - boardSize.width) / 2,
                y: size.height - boardSize.height
            )

            drawBackground(context: &context, origin: origin, boardSize: boardSize)
            drawLockedCells(context: &context, origin: origin, cellSize: cellSize)
            drawActivePiece(context: &context, origin: origin, cellSize: cellSize)
            drawGrid(context: &context, origin: origin, boardSize: boardSize, cellSize: cellSize)
        }
        .aspectRatio(20.0 / 40.0, contentMode: .fit)
    }

    private func drawBackground(context: inout GraphicsContext, origin: CGPoint, boardSize: CGSize) {
        let rect = CGRect(origin: origin, size: boardSize)
        context.fill(Path(rect), with: .color(Color.black.opacity(0.35)))
        context.stroke(Path(rect), with: .color(Color.white.opacity(0.35)), lineWidth: 1)
    }

    private func drawLockedCells(context: inout GraphicsContext, origin: CGPoint, cellSize: CGSize) {
        for y in 0..<Board.height {
            for x in 0..<Board.width {
                if let tetromino = board[x, y] {
                    drawCell(context: &context, x: x, y: y, tetromino: tetromino, origin: origin, cellSize: cellSize)
                }
            }
        }
    }

    private func drawActivePiece(context: inout GraphicsContext, origin: CGPoint, cellSize: CGSize) {
        guard let activePiece else { return }
        for point in activePiece.blocks where point.y >= 0 {
            drawCell(context: &context, x: point.x, y: point.y, tetromino: activePiece.tetromino, origin: origin, cellSize: cellSize)
        }
    }

    private func drawGrid(context: inout GraphicsContext, origin: CGPoint, boardSize: CGSize, cellSize: CGSize) {
        var grid = Path()

        for x in 0...Board.width {
            let lineX = origin.x + CGFloat(x) * cellSize.width
            grid.move(to: CGPoint(x: lineX, y: origin.y))
            grid.addLine(to: CGPoint(x: lineX, y: origin.y + boardSize.height))
        }

        for y in 0...Board.height {
            let lineY = origin.y + CGFloat(y) * cellSize.height
            grid.move(to: CGPoint(x: origin.x, y: lineY))
            grid.addLine(to: CGPoint(x: origin.x + boardSize.width, y: lineY))
        }

        context.stroke(grid, with: .color(Color.white.opacity(0.12)), lineWidth: 0.5)
    }

    private func drawCell(
        context: inout GraphicsContext,
        x: Int,
        y: Int,
        tetromino: Tetromino,
        origin: CGPoint,
        cellSize: CGSize
    ) {
        let inset = max(1, min(cellSize.width, cellSize.height) * 0.08)
        let rect = CGRect(
            x: origin.x + CGFloat(x) * cellSize.width + inset,
            y: origin.y + CGFloat(y) * cellSize.height + inset,
            width: cellSize.width - inset * 2,
            height: cellSize.height - inset * 2
        )
        let path = Path(roundedRect: rect, cornerRadius: max(1, min(cellSize.width, cellSize.height) * 0.12))

        context.fill(path, with: .color(color(for: tetromino)))
        context.stroke(path, with: .color(Color.white.opacity(0.28)), lineWidth: 0.5)
    }

    private func color(for tetromino: Tetromino) -> Color {
        switch tetromino {
        case .i: return .cyan
        case .o: return .yellow
        case .t: return .purple
        case .s: return .green
        case .z: return .red
        case .j: return .blue
        case .l: return .orange
        }
    }
}
