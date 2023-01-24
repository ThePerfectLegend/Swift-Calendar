//
//  StreakView.swift
//  Swift Calendar
//
//  Created by Nizami Tagiyev on 21.01.2023.
//

import SwiftUI
import CoreData

struct StreakView: View {
    
    @State private var streakValue = 0
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DayEntity.date, ascending: true)],
        predicate: NSPredicate(format: "date BETWEEN { %@, %@ }", Date().startOfMonth as CVarArg, Date().endOfMonth as CVarArg))
    private var days: FetchedResults<DayEntity>
    
    var body: some View {
        VStack {
            Text("\(streakValue)")
                .font(.system(size: 180, weight: .semibold, design: .rounded))
                .foregroundColor(streakValue > 0 ? .orange : .pink)
            Text("Current Streak")
                .font(.title2)
                .bold()
                .foregroundColor(.secondary)
        }
        .onAppear {
            streakValue = calculateStreakValue()
        }
    }
    
    func calculateStreakValue() -> Int {
        guard !days.isEmpty else { return 0 }
        
        let nonFutureDays = days
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
