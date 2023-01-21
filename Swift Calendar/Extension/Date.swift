//
//  Date.swift
//  Swift Calendar
//
//  Created by Nizami Tagiyev on 21.01.2023.
//

import Foundation

extension Date {

    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }

    var endOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.end
    }

    var endOfDay: Date {
        Calendar.current.dateInterval(of: .day, for: self)!.end
    }
    

    var startOfPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }

    var startOfNextMonth: Date {
        let dayInNextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self)!
        return dayInNextMonth.startOfMonth
    }

    var numberOfDaysInMonth: Int {
        // endOfMonth returns the 1st of next month at midnight.
        // An adjustment of -1 is necessary to get last day of current month
        let endDateAdjustment = Calendar.current.date(byAdding: .day, value: -1, to: self.endOfMonth)!
        return Calendar.current.component(.day, from: endDateAdjustment)
    }

    var dayInt: Int {
        Calendar.current.component(.day, from: self)
    }

    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }

    var monthFullName: String {
        self.formatted(.dateTime.month(.wide))
    }
    
    // MARK: Need to refactor by dynamic start of the week from calendar
    var startOfCalendarWithPrefixDays: Date {
//        let startOfMonthDay = Calendar.current.component(.weekday, from: startOfMonth)
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: startOfMonth)!
        return startDate
    }
}
