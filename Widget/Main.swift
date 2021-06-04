import WidgetKit
import SwiftUI
import Intents
import Combine

@main
struct AtCoderWidget: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetEntryView(intensity: entry.intensity)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
