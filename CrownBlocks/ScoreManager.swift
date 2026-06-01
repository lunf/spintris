import Foundation

struct ScoreManager: Equatable {
    private(set) var score = 0
    private(set) var lines = 0

    var level: Int {
        max(1, lines / 10 + 1)
    }

    var dropInterval: TimeInterval {
        max(0.12, 0.9 - (Double(level - 1) * 0.075))
    }

    mutating func addClearedLines(_ count: Int) {
        guard count > 0 else { return }
        let pointsTable = [0, 100, 300, 500, 800]
        score += pointsTable[min(count, 4)] * level
        lines += count
    }

    mutating func reset() {
        score = 0
        lines = 0
    }
}
