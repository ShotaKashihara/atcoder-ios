import SwiftUI
import Combine

enum Intensity {
    case level0
    case level1
    case level2
    case level3
    case level4

    var color: Color {
        switch self {
        case .level0: return .init(hex: "ebedf0")
        case .level1: return .init(hex: "9be9a8")
        case .level2: return .init(hex: "40c463")
        case .level3: return .init(hex: "30a14e")
        case .level4: return .init(hex: "216e39")
        }
    }

    static func check(_ count: Int) -> Self {
        switch count {
        case 0: return .level0
        case 1...3: return .level1
        case 4...7: return .level2
        case 8...15: return .level3
        default: return .level4
        }
    }
}

enum GetStreakUseCase {
    enum Failure: Error {
        case noData
        case requestError
    }

    static func invoke(user: String, in days: Int) -> AnyPublisher<[Intensity], Failure> {
        let now = Int(Date().timeIntervalSince1970)
        return AtCoderProblemsRepository.fetch(user: user)
            .map { submissions in
                submissions
                    .filter { $0.result == "AC" }
                    .map { s -> Int in
                        (now - s.epochSecond) / (24 * 60 * 60)
                    }
                    .reduce(into: [Int](repeating: 0, count: days)) { result, value in
                        guard days > value else { return }
                        result[value] += 1
                    }
                    .map(Intensity.check)
            }
            .mapError { _ in
                .requestError
            }
            .eraseToAnyPublisher()
    }

    static func invoke(user: String, in days: Int, callbackHandler: @escaping ([Intensity]) -> Void) {
        let now = Int(Date().timeIntervalSince1970)
        AtCoderProblemsRepository.fetch(user: user) { result in
            switch result {
            case .success(let submissions):
                let intensity = submissions
                    .filter { $0.result == "AC" }
                    .map { s -> Int in
                        (now - s.epochSecond) / (24 * 60 * 60)
                    }
                    .reduce(into: [Int](repeating: 0, count: days)) { result, value in
                        guard days > value else { return }
                        result[value] += 1
                    }
                    .map(Intensity.check)
                callbackHandler(intensity)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
