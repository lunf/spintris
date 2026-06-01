//
//  NextPiecePrevieiw.swift
//  CrownBlocks
//
//  Created by cuong.nguyenhat on 1/6/26.
//

import SwiftUI

struct NextPiecePreview: View {
    let tetromino: Tetromino

    var body: some View {
        Canvas { context, size in
            let blocks = tetromino.rotations[0]
            let minX = blocks.map(\.x).min() ?? 0
            let maxX = blocks.map(\.x).max() ?? 0
            let minY = blocks.map(\.y).min() ?? 0
            let maxY = blocks.map(\.y).max() ?? 0
            let blockWidth = maxX - minX + 1
            let blockHeight = maxY - minY + 1
            let cellSize = min(size.width / 4, size.height / 4)
            let pieceSize = CGSize(
                width: CGFloat(blockWidth) * cellSize,
                height: CGFloat(blockHeight) * cellSize
            )
            let origin = CGPoint(
                x: (size.width - pieceSize.width) / 2 - CGFloat(minX) * cellSize,
                y: (size.height - pieceSize.height) / 2 - CGFloat(minY) * cellSize
            )

            for block in blocks {
                let inset = max(0.8, cellSize * 0.1)
                let rect = CGRect(
                    x: origin.x + CGFloat(block.x) * cellSize + inset,
                    y: origin.y + CGFloat(block.y) * cellSize + inset,
                    width: cellSize - inset * 2,
                    height: cellSize - inset * 2
                )
                let path = Path(roundedRect: rect, cornerRadius: max(1, cellSize * 0.12))
                context.fill(path, with: .color(color(for: tetromino)))
                context.stroke(path, with: .color(.white.opacity(0.25)), lineWidth: 0.5)
            }
        }
        .frame(width: 30, height: 30)
        .padding(4)
        .background(.black.opacity(0.56), in: RoundedRectangle(cornerRadius: 5))
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
