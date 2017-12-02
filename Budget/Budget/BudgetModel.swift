//
//  BudgetModel.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/6/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import Foundation
import SQLite

enum ModelUpdate {
    case regulars, transactions, both
}

protocol ModelChangedDelegate {
    func modelChanged(_ modelUpdate: ModelUpdate)
}

class BudgetModel {
    static let shared = BudgetModel()
    
    private let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    private let database: Connection
    
    private var delegates = [ModelChangedDelegate]()
    
    private let regularsTable = Table("regulars")
    private struct regularsExpression {
        static let id = Expression<Int64>("id")
        static let name = Expression<String>("name")
        static let money = Expression<Double>("money")
        static let startingDate = Expression<Date>("startingDate")
        static let schedule = Expression<String>("schedule")
        static let scheduleData = Expression<Int64>("scheduleData")
    }
    
    private let transactionsTable = Table("transactions")
    private struct transactionsExpression {
        static let id = Expression<Int64>("id")
        static let name = Expression<String>("name")
        static let money = Expression<Double>("money")
        static let date = Expression<Date>("date")
    }
    
    var regulars: [Regular] {
        return Array(try! database.prepare(regularsTable)).map { row in
            return Regular(id: row[regularsExpression.id],
                            name: row[regularsExpression.name],
                            money: row[regularsExpression.money],
                            startingDate: row[regularsExpression.startingDate],
                            schedule: Regular.Schedule(rawValue: row[regularsExpression.schedule])!,
                            scheduleData: Int(row[regularsExpression.scheduleData]))
        }
    }
    
    var transactions: [Transaction] {
        return Array(try! database.prepare(transactionsTable)).map { row in
            return Transaction(id: row[transactionsExpression.id],
                           name: row[transactionsExpression.name],
                           money: row[transactionsExpression.money],
                           date: row[transactionsExpression.date])
        }
    }
    
    var isTutorialHasBeenShown: Bool {
        return UserDefaults.standard.bool(forKey: "isTutorialHasBeenShown")
    }
    
    private init() {
        database = try! Connection("\(documentsPath)/budget.sqlite3")
        
        //try! database.run(scheduledIncomesTable.drop(ifExists: true))
        
        try! database.run(regularsTable.create(ifNotExists: true) { t in
            t.column(regularsExpression.id, primaryKey: .autoincrement)
            t.column(regularsExpression.name, unique: true)
            t.column(regularsExpression.money)
            t.column(regularsExpression.startingDate)
            t.column(regularsExpression.schedule)
            t.column(regularsExpression.scheduleData)
        })
        
        try! database.run(transactionsTable.create(ifNotExists: true) { t in
            t.column(transactionsExpression.id, primaryKey: .autoincrement)
            t.column(transactionsExpression.name)
            t.column(transactionsExpression.money)
            t.column(transactionsExpression.date)
        })
    }
    
    @discardableResult
    func add(regular: Regular) -> Bool { // Success
        let name = regular.name
        let money =  regular.money
        let startingDate = regular.startingDate
        let schedule = regular.schedule
        let scheduleData = regular.scheduleData
        do {
            try database.run(regularsTable.insert(regularsExpression.name <- name,
                                                          regularsExpression.money <- money,
                                                          regularsExpression.startingDate <- startingDate,
                                                          regularsExpression.schedule <- schedule.rawValue,
                                                          regularsExpression.scheduleData <- Int64(scheduleData!)))
        } catch {
            return false
        }
        
        notifyDelegates(with: .regulars)
        
        return true
    }
    
    func replace(regularWithId id: Int64, with newRegular: Regular) {
        let query = regularsTable.filter(regularsExpression.id == id).update(regularsExpression.name <- newRegular.name,
                                                                             regularsExpression.money <- newRegular.money,
                                                                             regularsExpression.startingDate <- newRegular.startingDate,
                                                                             regularsExpression.schedule <- newRegular.schedule.rawValue,
                                                                             regularsExpression.scheduleData <- Int64(newRegular.scheduleData!))
        try! database.run(query)
        
        notifyDelegates(with: .regulars)
    }
    
    func deleteRegular(withId id: Int64) {
        let query = regularsTable.filter(regularsExpression.id == id).delete()
        
        try! database.run(query)
        
        notifyDelegates(with: .regulars)
    }
    
    @discardableResult
    func add(transaction: Transaction) -> Bool {
        let name = transaction.name
        let money =  transaction.money
        let date = transaction.date
        do {
            try database.run(transactionsTable.insert(transactionsExpression.name <- name,
                                                  transactionsExpression.money <- money,
                                                  transactionsExpression.date <- date))
        } catch {
            return false
        }
        
        notifyDelegates(with: .transactions)
        
        return true
    }
    
    func deleteTransaction(withId id: Int64) {
        let query = transactionsTable.filter(transactionsExpression.id == id).delete()
        
        try! database.run(query)
        
        notifyDelegates(with: .transactions)
    }
    
    func deleteAllContent() {
        try! database.run(regularsTable.delete())
        try! database.run(transactionsTable.delete())
        
        notifyDelegates(with: .both)
    }
    
    func moneyForDay(inDate date: Date, regulars: [Regular], transactions: [Transaction]) -> Double {
        let transactionsInDay = transactions.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        
        let transactionsMoney = transactionsInDay.reduce(0) { $0+$1.money }
        
        let regularsWithStartingDateBeforeDate = regulars.filter { Calendar.current.isDate($0.startingDate, inSameDayAs: date) || date > $0.startingDate }
        
        let regularsMoney = regularsWithStartingDateBeforeDate.reduce(Double(0)) { result, regular in
            var money: Double = 0
            
            switch regular.schedule {
            case .hourly:
                let hours = regular.scheduleData!
                
                money = Double(hours)*regular.money
            case .daily:
                money = regular.money
            case .weekly:
                var dayOfWeek = regular.scheduleData!+2
                if dayOfWeek == 8 {
                    dayOfWeek = 1
                }
                
                let dateDayOfWeek = Calendar.current.component(.weekday, from: date)
                
                if dayOfWeek == dateDayOfWeek {
                    money = regular.money
                }
            case .monthly:
                let dayInMonth = regular.scheduleData!
                
                let dateDayInMonth = Calendar.current.component(.day , from: date)
                
                if dayInMonth == dateDayInMonth {
                    money = regular.money
                }
            case .yearly:
                let dayInYear = regular.scheduleData!
                
                let dateDayInYear = Calendar.current.ordinality(of: .day, in: .year, for: date)
                
                if dayInYear == dateDayInYear {
                    money = regular.money
                }
            }
            
            return money+result
        }
        
        return transactionsMoney+regularsMoney
    }
    
    func moneyForMonth(ofDate date: Date, regulars: [Regular], transactions: [Transaction]) -> [Double] {
        let dates = [Int](1...Calendar.current.range(of: .day, in: .month, for: date)!.count).map { day -> Date in
            var components = Calendar.current.dateComponents([.day, .month, .year], from: date)
            components.day = day
            
            return Calendar.current.date(from: components)!
        }
        
        return dates.map { moneyForDay(inDate: $0, regulars: regulars, transactions: transactions) }
    }
    
    func weekDaySymbols(short: Bool = false) -> [String] {
        let weekdays = short ? Calendar.current.shortWeekdaySymbols : Calendar.current.weekdaySymbols
        
        var localizedWeekdays = [String]()
        
        if Calendar.current.firstWeekday == 2 {
            localizedWeekdays = weekdays[1...6]+[weekdays.first!]
        } else {
            localizedWeekdays = weekdays
        }
        
        return localizedWeekdays.map { $0.capitalized(with: Locale.current) }
    }
    
    func tutorialHasBeenShown() {
        UserDefaults.standard.set(true, forKey: "isTutorialHasBeenShown")
    }
    
    func addDelegate(_ delegate: ModelChangedDelegate) {
        delegates.append(delegate)
    }
    
    private func notifyDelegates(with modelUpdate: ModelUpdate) {
        delegates.forEach { $0.modelChanged(modelUpdate) }
    }
}
