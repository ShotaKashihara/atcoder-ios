import WidgetKit
import Intents
import SwiftUI
import Combine

struct Provider: IntentTimelineProvider {
    /// Timeline の更新
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        guard let userId = SharedUserDefaults.userId else {
            return
        }
        GetStreakUseCase.invoke(user: userId, in: 7*7) { intensity in
            let entry = SimpleEntry(intensity: intensity, configuration: ConfigurationIntent())
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }

    /// 主にギャラリーの Preview 表示
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        guard let userId = SharedUserDefaults.userId else {
            return
        }
        GetStreakUseCase.invoke(user: userId, in: 7*7) { intensity in
            let entry = SimpleEntry(intensity: intensity, configuration: ConfigurationIntent())
            completion(entry)
        }
    }

    /// デフォルト表示。ロード中とか
    func placeholder(in context: Context) -> SimpleEntry {
        return .init(intensity: [], configuration: ConfigurationIntent())
    }
}
