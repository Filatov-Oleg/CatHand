//
//  Date+Extension.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 11.01.2024.
//

import SwiftUI

extension Date {
    /// Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
    
    /// Checking Wheter the Date is Today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Checking if the date is same day
    var isSameDay: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .day) == .orderedSame
    }
    
    /// Checking if the date is same hour
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    
    /// Checking if the date is past hours
    var isPast: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }
    
    /// Fetching week based on given Date
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let startOfDate = calendar.startOfDay(for: date)
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let starOfWeek = weekForDate?.start else {
            return []
        }
        
        ///  Iterating to get the Full Week
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: starOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    /// Creating next week, based on the last current week's date
    func createNextWeek() -> [WeekDay] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        return fetchWeek(nextDate)
    }
    
    /// Creating previous week, based on the First current week's date
    func createPreviousWeek() -> [WeekDay] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        return fetchWeek(previousDate)
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

