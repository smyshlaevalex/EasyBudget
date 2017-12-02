//
//  ValuePickerViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/13/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class ValuePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var picker: UIPickerView!
    
    var schedule: Regular.Schedule!
    var complition: ((Int) -> ())!
    
    var hours = [Int](1...24)
    lazy var daysOfWeek: [String] = BudgetModel.shared.weekDaySymbols()
    var daysInMonth = [Int](1...31)
    var months = Calendar.current.monthSymbols

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch schedule! {
        case .hourly:
            navigationItem.title = NSLocalizedString("SELECT_AMOUNT_OF_HOURS", comment: "")
        case .weekly, .monthly:
            navigationItem.title = NSLocalizedString("SELECT_DAY", comment: "")
        case .yearly:
            navigationItem.title = NSLocalizedString("SELECT_DATE", comment: "")
        default:
            break;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch schedule! {
        case .hourly, .weekly, .monthly:
            return 1
        case .yearly:
            return 2
        default:
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch schedule! {
        case .hourly:
            return hours.count
        case .weekly:
            return daysOfWeek.count
        case .monthly:
            return daysInMonth.count
        case .yearly:
            return component == 0 ? daysInMonth.count : months.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch schedule! {
        case .hourly:
            return String(hours[row])
        case .weekly:
            return daysOfWeek[row]
        case .monthly:
            return String(daysInMonth[row])
        case .yearly:
            return component == 0 ? String(daysInMonth[row]) : months[row]
        default:
            return "Error"
        }
    }
    
    @IBAction func saveValue(_ sender: UIBarButtonItem) {
        switch schedule! {
        case .hourly:
            complition(hours[picker.selectedRow(inComponent: 0)])
        case .weekly:
            if Calendar.current.firstWeekday == 1 {
                complition(picker.selectedRow(inComponent: 0))
            } else {
                var weekday = picker.selectedRow(inComponent: 0)+1
                if weekday == 7 {
                    weekday = 0
                }
                
                complition(weekday)
            }
        case .monthly:
            complition(picker.selectedRow(inComponent: 0)+1)
        case .yearly:
            let dateComponent = DateComponents(era: 1, year: 2016, month: picker.selectedRow(inComponent: 1)+1, day: picker.selectedRow(inComponent: 0)+1)
            let date = Calendar.current.date(from: dateComponent)
            let day = Calendar.current.ordinality(of: .day, in: .year, for: date!)
            complition(day!)
        default:
            break
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
}
