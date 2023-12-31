//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Joel Storr on 15.10.23.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {

    // Dummy data of what the widget will look like
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date(), showFunFont: false)
    }

    func getSnapshot(
        for configuration: ChangeFontIntent,
        in context: Context,
        completion: @escaping (DayEntry) -> Void
    ) {
        let entry = DayEntry(date: Date(), showFunFont: false)
        completion(entry)
    }

    func getTimeline(
        for configuration: ChangeFontIntent,
        in context: Context,
        completion: @escaping (Timeline<DayEntry>) -> Void
    ) {
        var entries: [DayEntry] = []

        let showFunFont = configuration.funFont == 1

        // Generate a timeline consisting of seve entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDay = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDay, showFunFont: showFunFont)
            entries.append(entry)
        }

        // The policy says when to update the Timline in this case every 5 hours
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//      How does the Widget look right now (is shown in the Gallary when the user selects the widget)
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> DayEntry {
//        DayEntry(date: Date(), configuration: configuration)
//    }
//
//       Array of entries when the Widgtes changes
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<DayEntry> {
//        var entries: [DayEntry] = []
//
//        // Generate a timeline consisting of seve entries a day apart, starting from the current date.
//        let currentDate = Date()
//        for dayOffset in 0 ..< 7 {
//            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
//            let startOfDay = Calendar.current.startOfDay(for: entryDate)
//            let entry = DayEntry(date: startOfDay, configuration: configuration)
//            entries.append(entry)
//        }
//        
//        //The policy says when to update the Timline in this case every 5 hours
//        return Timeline(entries: entries, policy: .atEnd)
//    }
}

// Is the Data structure in the widget to populate it
struct DayEntry: TimelineEntry {
    let date: Date
    let showFunFont: Bool
}

// Swift UI View of you widget
struct MonthlyWidgetEntryView: View {

    var entry: DayEntry
    var config: MonthConfig
    let funFontName = "Chalkduster"

    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }

    var body: some View {
        ZStack {
           ContainerRelativeShape()
                .fill(config.backgroundColor)
            VStack {
                HStack(spacing: 4) {
                    Text(config.emojiText)
                        .font(.title)
                    Text(entry.date.weekdayDisplayFormat)
                        .font(entry.showFunFont ? .custom(funFontName, size: 24) : .title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .foregroundStyle(config.weekdayTextColor)
                }
                Text(entry.date.dayDisplayFormat)
                    .font(entry.showFunFont ? .custom(funFontName, size: 80) : .system(size: 80, weight: .heavy))
                    .foregroundStyle(config.dayTextColor)
            }
            .containerBackground(for: .widget) {
                config.backgroundColor
            }
        }
    }
}

// The Actual Widget
struct MonthlyWidget: Widget {

    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ChangeFontIntent.self, provider: Provider()) { entry in
            MonthlyWidgetEntryView(entry: entry)
        }

        // Default Config
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            MonthlyWidgetEntryView(entry: entry)
//                //.containerBackground(.fill.tertiary, for: .widget)
//        }
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes based on month")
        .supportedFamilies([.systemSmall])
    }
}

// Disspalys the Infos to the widget in the Gallery
extension ConfigurationAppIntent {

    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

extension Date {

    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }

    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}

#Preview(as: .systemSmall) {
    MonthlyWidget()
} timeline: {
    DayEntry(date: .now, showFunFont: false)
    DayEntry(date: .now, showFunFont: false)
}
