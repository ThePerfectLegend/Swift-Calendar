//
//  CalendarWidget.swift
//  CalendarWidget
//
//  Created by Nizami Tagiyev on 23.01.2023.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    
    // MARK: Preparing CoreData
    let viewContext = PersistenceController.shared.container.viewContext
    var daysFetchRequest: NSFetchRequest<DayEntity> {
        let request = DayEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DayEntity.date, ascending: true)]
        request.predicate = NSPredicate(format: "date BETWEEN { %@, %@ }",
                                        Date().startOfCalendarWithPrefixDays as CVarArg,
                                        Date().endOfMonth as CVarArg)
        return request
    }
    
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), days: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        do {
            let days = try viewContext.fetch(daysFetchRequest)
            let entry = CalendarEntry(date: Date(), days: days)
            completion(entry)
        } catch {
            print("Widget failed to fetch dates in snapshot")
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let days = try viewContext.fetch(daysFetchRequest)
            let entry = CalendarEntry(date: Date(), days: days)
            let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
            completion(timeline)
        } catch {
            print("Widget failed to fetch dates in timeline")
        }
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let days: [DayEntity]
}

struct CalendarWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: CalendarEntry
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        switch family {
        case .systemMedium:
            HStack {
                Link(destination: URL(string: "streak")!) {
                    VStack {
                        Text("\(calculateStreakValue())")
                            .font(.system(size: 70, design: .rounded))
                            .bold()
                            .foregroundColor(.orange)
                        Text("Day streak")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Link(destination: URL(string: "calendar")!) {
                    VStack {
                        CalendarHeaderView(font: .caption)
                        LazyVGrid(columns: columns, spacing: 6) {
                            ForEach(entry.days) { day in
                                if day.date!.monthInt != Date().monthInt {
                                    Text("")
                                } else {
                                    Text(day.date!.formatted(.dateTime.day()))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(day.didStudy ? .orange : .secondary)
                                        .background(
                                            Circle()
                                                .foregroundColor(.orange.opacity(day.didStudy ? 0.3 : 0))
                                                .scaleEffect(1.25)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.leading, 6)
                }
            }
            .padding()
        case .accessoryInline:
            Label("Streak - \(calculateStreakValue()) days", systemImage: "swift")
                .widgetURL(URL(string: "streak")!)
        case .accessoryRectangular:
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(entry.days) { day in
                    if day.date!.monthInt != Date().monthInt {
                        Text("")
                            .font(.system(size: 7))
                    } else {
                        if day.didStudy {
                            Image(systemName: "swift")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 7, height: 7)
                        } else {
                            Text(day.date!.formatted(.dateTime.day()))
                                .font(.system(size: 7))
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .widgetURL(URL(string: "calendar")!)
        case .accessoryCircular:
            Gauge(value: Double(calculateStreakValue()), in: 1...Double(entry.days.count)) {
                Image(systemName: "swift")
            } currentValueLabel: {
                Text("\(calculateStreakValue())")
            }
            .gaugeStyle(.accessoryCircular)
            .widgetURL(URL(string: "streak")!)
        default:
            EmptyView()
        }
    }
    
    func calculateStreakValue() -> Int {
        guard !entry.days.isEmpty else { return 0 }
        
        let nonFutureDays = entry.days
            .filter { $0.date!.dayInt <= Date().dayInt }
        
        var streakCount = 0
        
        for day in nonFutureDays.reversed() {
            if day.didStudy {
                streakCount += 1
            } else {
                if day.date!.dayInt != Date().dayInt {
                    break
                }
            }
        }
        return streakCount
    }
}

struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Swift Study Calendar")
        .description("Track days you study Swift.")
        .supportedFamilies([.systemMedium, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}
