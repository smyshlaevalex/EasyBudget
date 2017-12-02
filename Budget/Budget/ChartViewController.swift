//
//  ChartViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 1/17/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit
import Chameleon

class ChartViewController: UIViewController, UIToolbarDelegate {
    @IBOutlet weak var chartView: ChartView!
    
    var regulars = [Regular]()
    var transactions = [Transaction]()
    
    let months = Calendar.current.shortMonthSymbols.map { month -> String in
        if month.count > 3 {
            let index = month.index(month.startIndex, offsetBy: 3)
            return String(month[..<index])
        }
        return month
    }
    
    var moneyInCurrentMonth = [Double]()
    var moneyInCurrentYear = [Double]()
    var moneyForChart = [Double]()
    var maxMoney: Double = 0
    var minMoney: Double = 0
    
    var amountOfMoneyInStep = 0
    
    enum ChartMode: Int {
        case days, months
    }
    
    var currentChartMode = ChartMode.days

    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.dataSource = self
        
        BudgetModel.shared.addDelegate(self)
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesNavigationBarHairline = true
        
        updateChart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chartView.createViews()
    }
    
    func calculateMoneyFor(chartMode: ChartMode) {
        switch chartMode {
        case .days:
            moneyInCurrentMonth = BudgetModel.shared.moneyForMonth(ofDate: Date(), regulars: regulars, transactions: transactions)
            
            moneyForChart = []
            
            for (index, money) in moneyInCurrentMonth.enumerated() {
                var newMoney = money
                
                if index > 0 {
                    newMoney += moneyForChart[index-1]
                }
                
                moneyForChart.append(newMoney)
            }
            
            maxMoney = moneyForChart.reduce(0) { $1 > $0 ? $1 : $0 }
            minMoney = moneyForChart.reduce(0) { $1 < $0 ? $1 : $0 }
        case .months:
            let currentMonth = Calendar.current.component(.month, from: Date())
            let yearDates = (1...currentMonth).map { month -> Date in
                var components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
                components.month = month
                
                return Calendar.current.date(from: components)!
            }
            
            moneyInCurrentYear = yearDates.map { BudgetModel.shared.moneyForMonth(ofDate: $0, regulars: self.regulars, transactions: self.transactions).reduce(0, +) }
            
            moneyForChart = []
            
            for (index, money) in moneyInCurrentYear.enumerated() {
                var newMoney = money
                
                if index > 0 {
                    newMoney += moneyForChart[index-1]
                }
                
                moneyForChart.append(newMoney)
            }
            
            maxMoney = moneyForChart.reduce(0) { $1 > $0 ? $1 : $0 }
            minMoney = moneyForChart.reduce(0) { $1 < $0 ? $1 : $0 }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func rangeChanged(_ sender: UISegmentedControl) {
        currentChartMode = ChartMode(rawValue: sender.selectedSegmentIndex)!
        
        calculateMoneyFor(chartMode: currentChartMode)
        
        chartView.createViews()
    }
    
    func updateChart() {
        regulars = BudgetModel.shared.regulars
        transactions = BudgetModel.shared.transactions
        
        calculateMoneyFor(chartMode: currentChartMode)
        
        chartView.createViews()
    }
}

extension ChartViewController: ModelChangedDelegate {
    func modelChanged(_ modelUpdate: ModelUpdate) {
        updateChart()
    }
}

extension ChartViewController: ChartViewDataSource {
    var labelOffset: UIOffset {
        return UIOffset(horizontal: 50, vertical: 30)
    }
    
    var xAxisMax: Int {
        switch currentChartMode {
        case .days:
            return Calendar.current.range(of: .day, in: .month, for: Date())!.count
        case .months:
            return moneyInCurrentYear.count
        }
    }
    
    var yAxisMax: Int {
        let moneyZeroDifference = max(abs(maxMoney), abs(minMoney))
        
        if 0..<10000 ~= moneyZeroDifference {
            amountOfMoneyInStep = 1000
        } else if 10000..<50000 ~= moneyZeroDifference {
            amountOfMoneyInStep = 10000
        } else if 50000..<400000 ~= moneyZeroDifference {
            amountOfMoneyInStep = 50000
        } else if 400000..<1000000 ~= moneyZeroDifference {
            amountOfMoneyInStep = 100000
        } else {
            amountOfMoneyInStep = 200000
        }
        
        let positives = (Int(abs(maxMoney))/amountOfMoneyInStep)+2
        let negatives = (Int(abs(minMoney))/amountOfMoneyInStep)+1
        
        return positives+negatives
    }
    
    var xLabelDistance: CGFloat {
        return 30
    }
    
    var yLabelDistance: CGFloat {
        return 50
    }
    
    func chartView(_ chartView: ChartView, labelForXaxis xAxis: Int) -> String {
        switch currentChartMode {
        case .days:
            return String(xAxis+1)
        case .months:
            return months[xAxis]
        }
    }
    
    func chartView(_ chartView: ChartView, labelForYaxis yAxis: Int) -> String {
        let negatives = (Int(abs(minMoney))/amountOfMoneyInStep)+1
        
        return String((yAxis-negatives)*amountOfMoneyInStep)
    }
    
    var points: [CGPoint] {
        let negatives = (Int(abs(minMoney))/amountOfMoneyInStep)+1
        
        return moneyForChart.enumerated().map { CGPoint(x: CGFloat($0)*xLabelDistance, y: CGFloat($1)/CGFloat(amountOfMoneyInStep)*(yLabelDistance)+(CGFloat(negatives)*yLabelDistance)) }
    }
    
    var labelsColor: UIColor {
        return UIColor.flatMintDark
    }
    
    var lineColor: UIColor {
        return UIColor.flatMintDark
    }
    
    var lineWidth: CGFloat {
        return 4
    }
}
