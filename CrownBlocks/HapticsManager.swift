import WatchKit

final class HapticsManager: GameFeedbackProviding {
    func pieceLocked() {
        WKInterfaceDevice.current().play(.click)
    }

    func linesCleared() {
        WKInterfaceDevice.current().play(.success)
    }

    func gameOver() {
        WKInterfaceDevice.current().play(.failure)
    }
}
