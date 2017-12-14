//
//  ScheduledIncome.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/6/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import Foundation

struct Regular {
    enum Schedule: String {
        case hourly = "hourly"
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
        case yearly = "yearly"
    }
    
    var id: Int64?
    var name: String
    var money: Double
    var startingDate: Date
    var schedule: Schedule
    var scheduleData: Int?
    
    init(id: Int64? = nil, name: String, money: Double, startingDate: Date, schedule: Schedule, scheduleData: Int? = nil) {
        self.id = id
        self.name = name
        self.money = money
        self.startingDate = startingDate
        self.schedule = schedule
        self.scheduleData = scheduleData
    }
    
    static func localizedDescription(schedule: Schedule, scheduleData: Int?) -> String {
        switch schedule {
        case .hourly:
            return String(format: NSLocalizedString("SCHEDULED_HOURLY", comment: ""), scheduleData!)
        case .daily:
            return NSLocalizedString("DAILY", comment: "")
        case .weekly:
            var daysOfWeek = Calendar.current.weekdaySymbols
            return String(format: NSLocalizedString("SCHEDULED_WEEKLY", comment: ""), daysOfWeek[scheduleData!])
        case .monthly:
            return String(format: NSLocalizedString("SCHEDULED_MONTHLY", comment: ""), scheduleData!)
        case .yearly:
            let dateComponent = DateComponents(era: 1, year: 2016, month: 1, day: scheduleData!)
            let date = Calendar.current.date(from: dateComponent)
            let day = Calendar.current.component(.day, from: date!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let month = dateFormatter.string(from: date!)
            return String(format: NSLocalizedString("SCHEDULED_YEARLY", comment: ""), day, month)
        }
    }
}
