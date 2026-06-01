import Foundation

enum HorizontalMove {
    case left
    case right
}

struct CrownInputController {
    private let threshold: Double
    private var anchorValue: Double

    init(threshold: Double = 1.0, initialValue: Double = 0) {
        self.threshold = threshold
        self.anchorValue = initialValue
    }

    mutating func move(for newValue: Double) -> HorizontalMove? {
        let delta = newValue - anchorValue
        guard abs(delta) >= threshold else { return nil }

        anchorValue = newValue
        return delta > 0 ? .right : .left
    }

    mutating func reset(to value: Double) {
        anchorValue = value
    }
}
