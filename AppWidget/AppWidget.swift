//
//  AppWidget.swift
//  AppWidget
//
//  Created by Konstantin Zaharev on 30.01.2022.
//

import WidgetKit
import SwiftUI

@main
struct AppWidget: Widget {
 
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "AppWidget",
            provider: Provider()
        ){ entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName("AppSUI06HW widget")
        .description("This is an widget for AppSUI06HW.")
    }
}

struct Provider: TimelineProvider {
    
    @AppStorage("statistics", store: UserDefaults(suiteName: "group.com.zakk.AppSUI06HW"))
    var statisticsData: Data = Data()
    
    func placeholder(in context: Context) -> StatisticsEntry {
        StatisticsEntry(statistics: nil)
    }
        
    func getSnapshot(in context: Context, completion: @escaping (StatisticsEntry) -> Void) {
        guard let statistics = try? JSONDecoder().decode([SearchResult].self, from: statisticsData) else { return }
        let entry = StatisticsEntry(statistics: statistics)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StatisticsEntry>) -> Void) {
        guard let statistics = try? JSONDecoder().decode([SearchResult].self, from: statisticsData) else { return }
        let entry = StatisticsEntry(statistics: statistics)
        let timeline = Timeline(entries:[entry], policy: .never)
        completion(timeline)
    }
}

struct StatisticsEntry: TimelineEntry {
    let date: Date = Date()
    let statistics: [SearchResult]?
}

struct AppWidget_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: StatisticsEntry(statistics: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
