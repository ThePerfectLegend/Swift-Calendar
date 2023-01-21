//
//  CalendarView.swift
//  Swift Calendar
//
//  Created by Nizami Tagiyev on 19.01.2023.
//

import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DayEntity.date, ascending: true)],
        predicate: NSPredicate(format: "date BETWEEN { %@, %@ }", Date().startOfCalendarWithPrefixDays as CVarArg, Date().endOfMonth as CVarArg))
    private var days: FetchedResults<DayEntity>
    private let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach(daysOfWeek, id: \.self) { dayOfWeek in
                        Text(dayOfWeek)
                            .fontWeight(.black)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                    }
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days) { day in
                        if day.date!.monthInt != Date().monthInt {
                            Text("")
                        } else {
                            Text(day.date!.formatted(.dateTime.day()))
                                .bold()
                                .foregroundColor(day.didStudy ? .orange : .secondary)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    Circle()
                                        .foregroundColor(.orange.opacity(day.didStudy ? 0.3 : 0))
                                )
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .padding()
            .onAppear {
                if days.isEmpty {
                    createMonthDays(for: .now.startOfPreviousMonth)
                    createMonthDays(for: .now)
                } else if days.count < 10 {
                    createMonthDays(for: .now)
                }
            }
        }
    }
    
    func createMonthDays(for date: Date) {
        for dayOffset in 0..<date.numberOfDaysInMonth {
            let newDay = DayEntity(context: viewContext)
            newDay.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: date.startOfMonth)
            newDay.didStudy = false
        }
        
        do {
            try viewContext.save()
            print("✅ \(date.monthFullName) days created")
        } catch {
            print("❌ Failed to save calendar days")
        }
    }
}
