import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date = Date()
    let intensity: [Intensity]
    let configuration: ConfigurationIntent
}

extension Submission {
    static var dummy: Submission {
        return .init(
            id: Int.random(in: 1..<9), epochSecond: 0, problemId: "", contestId: "", userId: "", language: "", point: 0, length: 0, result: "", executionTime: nil)
    }
}

extension Array where Element == Submission {
    static var dummy: [Element] {
        return Array.init(repeating: .dummy, count: 100)
    }
}

struct WidgetEntryView : View {
    let intensity: [Intensity]

    var body: some View {
        StreakInnerView(size: .last7Weeks, intensity: intensity)
            .padding(16)
            .clipShape(
                ContainerRelativeShape().inset(by: 16)
            )
    }
}

struct WidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(intensity: [])
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
