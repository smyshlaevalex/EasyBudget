//
//  CalendarTableViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 1/15/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarTableViewController: UITableViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var moneyInDayLabel: UILabel!
    
    @IBOutlet var weekdayLabels: [UILabel]!
    
    let weekdays = BudgetModel.shared.weekDaySymbols(short: true)
    
    let indateColor = UIColor.black
    let outdateColor = UIColor.gray
    let daySelectedColor = UIColor.white
    let todayColor = UIColor.flatRed
    let selectedColor = UIColor.flatMintDark
    
    let eventColor = UIColor.flatMintDark
    
    var regulars = [Regular]()
    var transactions = [Transaction]()
    var regularsInCurentDate = [Regular]()
    var transactionsInCurrentDate = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "DayCell")
        calendarView.cellInset = CGPoint.zero
        
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: nil, completionHandler: {
            self.calendarView.selectDates([Date()])
        })
        
        tableView.tableFooterView = UIView()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        regulars = BudgetModel.shared.regulars
        transactions = BudgetModel.shared.transactions
        
        calendarView.reloadData()
        
        for weekdayLabel in weekdayLabels {
            weekdayLabel.text = weekdays[weekdayLabel.tag]
        }
        
        if let date = calendarView.selectedDates.first {
            regularsInCurentDate = regulars.filter { Calendar.current.isDate($0.startingDate, inSameDayAs: date) }
            transactionsInCurrentDate = transactions.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            tableView.reloadData()
            
            reloadMoneyInDay(date: date)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (regularsInCurentDate.isEmpty ? 0 : 1) + (transactionsInCurrentDate.isEmpty ? 0 : 1)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if regularsInCurentDate.isEmpty {
            return NSLocalizedString("TRANSACTIONS", comment: "")
        } else {
            if section == 0 {
                return NSLocalizedString("REGULARS", comment: "")
            } else {
                return NSLocalizedString("TRANSACTIONS", comment: "")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if regularsInCurentDate.isEmpty {
            return transactionsInCurrentDate.count
        } else {
            if section == 0 {
                return regularsInCurentDate.count
            } else {
                return transactionsInCurrentDate.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if regularsInCurentDate.isEmpty {
            return 84
        } else {
            if indexPath.section == 0 {
                return 44
            } else {
                return 84
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if regularsInCurentDate.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionCell
            
            let transaction = transactionsInCurrentDate[indexPath.row]
            
            cell.nameLabel.text = transaction.name
            cell.money = transaction.money
            cell.date = transaction.date
            
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "regularCell", for: indexPath)
                
                let regular = regularsInCurentDate[indexPath.row]
                
                cell.textLabel?.text = regular.name
                
                cell.detailTextLabel?.text = "\(abs(regular.money).cleanString) р."
                
                if regular.money > 0 {
                    cell.detailTextLabel?.textColor = UIColor.flatGreenDark
                } else {
                    cell.detailTextLabel?.textColor = UIColor.flatRedDark
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionCell
                
                let transaction = transactionsInCurrentDate[indexPath.row]
                
                cell.nameLabel.text = transaction.name
                cell.money = transaction.money
                cell.date = transaction.date
                
                return cell
            }
        }
    }
    
    func reloadMoneyInDay(date: Date) {
        let moneyInDay = BudgetModel.shared.moneyForDay(inDate: date, regulars: regulars, transactions: transactions)
        
        moneyInDayLabel.text = "\(abs(moneyInDay).cleanString) р."
        
        if moneyInDay > 0 {
            moneyInDayLabel.textColor = UIColor.flatGreenDark
        } else {
            moneyInDayLabel.textColor = UIColor.flatRedDark
        }
    }

    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        guard let dayCell = view as? DayCell else {
            return
        }
        
        if cellState.isSelected {
            dayCell.dayLabel.textColor = daySelectedColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                if Calendar.current.isDateInToday(cellState.date) {
                    dayCell.dayLabel.textColor = todayColor
                } else {
                    dayCell.dayLabel.textColor = indateColor
                }
                
            } else {
                dayCell.dayLabel.textColor = outdateColor
            }
        }
    }
    
    
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let dayCell = view as? DayCell else {
            return
        }
        
        if cellState.isSelected {
            dayCell.selectedView.layer.cornerRadius = dayCell.selectedView.bounds.width/2
            dayCell.selectedView.isHidden = false
            
            if Calendar.current.isDateInToday(cellState.date) {
                dayCell.selectedView.backgroundColor = todayColor
            } else {
                dayCell.selectedView.backgroundColor = selectedColor
            }
        } else {
            dayCell.selectedView.isHidden = true
        }
    }
    
    func handleCellEvent(view: JTAppleDayCellView?, cellState: CellState) {
        guard let dayCell = view as? DayCell else {
            return
        }
        
        if !transactions.filter({ Calendar.current.isDate($0.date, inSameDayAs: cellState.date) }).isEmpty || !regulars.filter({ Calendar.current.isDate($0.startingDate, inSameDayAs: cellState.date) }).isEmpty {
            dayCell.eventView.isHidden = false
            if cellState.isSelected {
                dayCell.eventView.backgroundColor = daySelectedColor
            } else {
                dayCell.eventView.backgroundColor = eventColor
            }
        } else {
            dayCell.eventView.isHidden = true
        }
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        var earliestDate = Date()
        
        for regular in regulars {
            if regular.startingDate < earliestDate {
                earliestDate = regular.startingDate
            }
        }
        
        for transaction in transactions {
            if transaction.date < earliestDate {
                earliestDate = transaction.date
            }
        }
        var latiestDate = Date()
        
        for regular in regulars {
            if regular.startingDate > latiestDate {
                latiestDate = regular.startingDate
            }
        }
        
        for transaction in transactions {
            if transaction.date > latiestDate {
                latiestDate = transaction.date
            }
        }
        
        let startDate = earliestDate
        let endDate = latiestDate
        let parameters = ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: DaysOfWeek(rawValue: Calendar.current.firstWeekday)!
        )
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let dayCell = cell as! DayCell
        
        dayCell.dayLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        handleCellEvent(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        handleCellEvent(view: cell, cellState: cellState)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        let formatedDate = formatter.string(from: cellState.date).capitalized
        
        navigationItem.title = formatedDate
        
        if cellState.dateBelongsTo == .previousMonthWithinBoundary {
            calendar.scrollToSegment(.previous)
        } else if cellState.dateBelongsTo == .followingMonthWithinBoundary {
            calendar.scrollToSegment(.next)
        }
        
        regularsInCurentDate = regulars.filter { Calendar.current.isDate($0.startingDate, inSameDayAs: date) }
        transactionsInCurrentDate = transactions.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        tableView.reloadData()
        
        reloadMoneyInDay(date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        handleCellEvent(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        let formatedDate = formatter.string(from: date).capitalized
        
        navigationItem.title = formatedDate
    }
    
    @IBAction func jumpToToday(_ sender: UIBarButtonItem) {
        calendarView.selectDates([Date()])
        calendarView.scrollToDate(Date())
    }
}
