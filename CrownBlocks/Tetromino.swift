import Foundation

enum Tetromino: CaseIterable, Equatable {
    case i
    case o
    case t
    case s
    case z
    case j
    case l

    static func random() -> Tetromino {
        allCases.randomElement() ?? .t
    }

    var rotations: [[BoardPoint]] {
        switch self {
        case .i:
            return [
                [BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1), BoardPoint(x: 3, y: 1)],
                [BoardPoint(x: 2, y: 0), BoardPoint(x: 2, y: 1), BoardPoint(x: 2, y: 2), BoardPoint(x: 2, y: 3)]
            ]
        case .o:
            return [
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 2, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1)]
            ]
        case .t:
            return [
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1)],
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1), BoardPoint(x: 1, y: 2)],
                [BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1), BoardPoint(x: 1, y: 2)],
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1), BoardPoint(x: 1, y: 2)]
            ]
        case .s:
            return [
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 2, y: 0), BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1)],
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1), BoardPoint(x: 2, y: 2)]
            ]
        case .z:
            return [
                [BoardPoint(x: 0, y: 0), BoardPoint(x: 1, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1)],
                [BoardPoint(x: 2, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1), BoardPoint(x: 1, y: 2)]
            ]
        case .j:
            return [
                [BoardPoint(x: 0, y: 0), BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1)],
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 2, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 1, y: 2)],
                [BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1), BoardPoint(x: 2, y: 2)],
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 0, y: 2), BoardPoint(x: 1, y: 2)]
            ]
        case .l:
            return [
                [BoardPoint(x: 2, y: 0), BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1)],
                [BoardPoint(x: 1, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 1, y: 2), BoardPoint(x: 2, y: 2)],
                [BoardPoint(x: 0, y: 1), BoardPoint(x: 1, y: 1), BoardPoint(x: 2, y: 1), BoardPoint(x: 0, y: 2)],
                [BoardPoint(x: 0, y: 0), BoardPoint(x: 1, y: 0), BoardPoint(x: 1, y: 1), BoardPoint(x: 1, y: 2)]
            ]
        }
    }
}

struct BoardPoint: Equatable, Hashable {
    var x: Int
    var y: Int
}
