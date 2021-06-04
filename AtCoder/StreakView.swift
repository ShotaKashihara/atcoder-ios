import SwiftUI
import Combine

struct StreakInnerView: View {
    let size: (x: Int, y: Int)
    let boardColors: Array2D<Color>

    init(size: Size, intensity: [Intensity]) {
        switch size {
        case .last7Weeks:
            self.size = (7, 7)
        }
        var intensity: [Intensity?] = intensity
        // 明日から週末までを blank とし、空白 (nil) で埋める
        if let weekday = Calendar.current.dateComponents(in: .current, from: Date()).weekday {
            let offset = 7 - weekday // weekday: 1...7
            intensity.insert(contentsOf: [Intensity?](repeating: nil, count: offset), at: 0)
        }
        var boardColors = Array2D<Color>.init(repeating: .clear, self.size.x, self.size.y)
        for (offset, element) in intensity.enumerated() {
            boardColors[
                boardColors.x - (offset / boardColors.y) - 1,
                boardColors.y - (offset % boardColors.y) - 1
            ] = element?.color ?? .clear
        }
        self.boardColors = boardColors
    }

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<size.x) { x in
                VStack(spacing: 3) {
                    ForEach(0..<size.y) { y in
                        MiniView(color: boardColors[x, y])
                    }
                }
            }
        }
    }
}

enum Size {
    case last7Weeks

    var size: (x: Int, y: Int) {
        switch self {
        case .last7Weeks:
            return (7, 7)
        }
    }
}

struct StreakView: View {
    @ObservedObject
    var viewModel: StreakViewModel
    let size: Size

    init(size: Size) {
        self.size = size
        self.viewModel = .init(size: size)
    }

    var body: some View {
        StreakInnerView(size: size, intensity: viewModel.intensity)
            .padding(16)
            .clipShape(
                ContainerRelativeShape().inset(by: 16)
            )
    }
}

class StreakViewModel: ObservableObject {
    @Published
    var intensity = [Intensity]()
    var subscriptions = Set<AnyCancellable>()

    init(size: Size) {
        guard let userId = SharedUserDefaults.userId else {
            return
        }
        GetStreakUseCase.invoke(user: userId, in: size.size.x * size.size.y)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                print(result)
            }, receiveValue: { [weak self] value in
                self?.intensity = value
            })
            .store(in: &subscriptions)
    }
}

struct StreakView_Previews: PreviewProvider {
    static var previews: some View {
        StreakView(size: .last7Weeks)
    }
}
