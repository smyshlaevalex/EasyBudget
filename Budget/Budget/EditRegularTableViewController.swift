//
//  EditScheduledIncomeTableViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/11/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class EditRegularTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var startingDateLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    enum ScheduledType {
        case salary, tax
    }
    
    enum RegularEditorType {
        case add(ScheduledType)
        case edit(Regular)
    }
    
    var regularEditorType: RegularEditorType!
    
    var schedule: Regular.Schedule? {
        didSet {
            guard let schedule = schedule else {
                return
            }
            
            if schedule == .daily {
                scheduleLabel.text = NSLocalizedString("DAILY", comment: "")
            }
        }
    }
    
    var scheduleData: Int? {
        didSet {
            guard let schedule = schedule else {
                return
            }
            
            scheduleLabel.text = Regular.russificated(schedule: schedule, scheduleData: scheduleData)
        }
    }
    
    var startingDate: Date! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            startingDateLabel.text = dateFormatter.string(from: startingDate)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        switch regularEditorType! {
        case .add(let scheduledType):
            navigationItem.title = NSLocalizedString("ADD", comment: "")
            
            moneyTextField.textColor = scheduledType == .salary ? UIColor.flatGreenDark : UIColor.flatRedDark
            
            nameTextField.becomeFirstResponder()
            
            startingDate = Date()
        case .edit(let regular):
            navigationItem.title = NSLocalizedString("EDIT", comment: "")
            
            nameTextField.text = regular.name
            moneyTextField.text = abs(regular.money).cleanString
            moneyTextField.textColor = regular.money > 0 ? UIColor.flatGreenDark : UIColor.flatRedDark
            startingDate = regular.startingDate
            schedule = regular.schedule
            scheduleData = regular.scheduleData
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let highlightedIndexPaths = [IndexPath(row: 0, section: 1),
                                     IndexPath(row: 0, section: 2)]
        
        return highlightedIndexPaths.first(where: { $0 == indexPath }) != nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            let actionSheet = UIAlertController(title: NSLocalizedString("TYPE", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            let hourlyAction = UIAlertAction(title: NSLocalizedString("HOURLY", comment: ""), style: .default, handler: { _ in
                self.schedule = .hourly
                self.performSegue(withIdentifier: "ValuePickerSegue", sender: self)
            })
            let dailyAction = UIAlertAction(title: NSLocalizedString("DAILY", comment: ""), style: .default, handler: { _ in
                self.schedule = .daily
            })
            let weeklyAction = UIAlertAction(title: NSLocalizedString("WEEKLY", comment: ""), style: .default, handler: { _ in
                self.schedule = .weekly
                self.performSegue(withIdentifier: "ValuePickerSegue", sender: self)
            })
            let monthlyAction = UIAlertAction(title: NSLocalizedString("MONTHLY", comment: ""), style: .default, handler: { _ in
                self.schedule = .monthly
                self.performSegue(withIdentifier: "ValuePickerSegue", sender: self)
            })
            let yearlyAction = UIAlertAction(title: NSLocalizedString("YEARLY", comment: ""), style: .default, handler: { _ in
                self.schedule = .yearly
                self.performSegue(withIdentifier: "ValuePickerSegue", sender: self)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel, handler: nil)
            
            actionSheet.addAction(hourlyAction)
            actionSheet.addAction(dailyAction)
            actionSheet.addAction(weeklyAction)
            actionSheet.addAction(monthlyAction)
            actionSheet.addAction(yearlyAction)
            actionSheet.addAction(cancelAction)
            
            actionSheet.modalPresentationStyle = .popover
            actionSheet.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
            actionSheet.popoverPresentationController?.sourceRect = tableView.cellForRow(at: indexPath)!.bounds
            
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            moneyTextField.becomeFirstResponder()
        case moneyTextField:
            moneyTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case moneyTextField:
            let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
            return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        default:
            return true
        }
    }
    
    @IBAction func saveRegular(_ sender: UIBarButtonItem) {
        if let name = nameTextField.text, !name.isEmpty {
            if let money = Double(moneyTextField.text!) {
                if let startingDate = startingDate {
                    if let schedule = schedule {
                        switch regularEditorType! {
                        case .add(let scheduledType):
                            let regular = Regular(name: name, money: (scheduledType == .salary) ? money : -money, startingDate: startingDate, schedule: schedule, scheduleData: scheduleData ?? 0)
                            
                            BudgetModel.shared.add(regular: regular)
                            
                            _ = navigationController?.popViewController(animated: true)
                        case .edit(let oldRegular):
                            let newRegular = Regular(name: name, money: oldRegular.money > 0 ? money : -money, startingDate: startingDate, schedule: schedule, scheduleData: scheduleData ?? 0)
                            
                            BudgetModel.shared.replace(regularWithId: oldRegular.id!, with: newRegular)
                            
                            _ = navigationController?.popToRootViewController(animated: true)
                        }
                        
                        return
                    }
                }
            }
        }
        
        let alert = UIAlertController(title: NSLocalizedString("BLANK_FIELDS", comment: ""), message: NSLocalizedString("FILL_FIELDS", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "DatePickerSegue":
            let destination = segue.destination as! DatePickerViewController
            
            destination.defaultDate = startingDate
            destination.complition = { self.startingDate = $0 }
        case "ValuePickerSegue":
            let destination = segue.destination as! ValuePickerViewController
            
            destination.schedule = schedule
            destination.complition = { self.scheduleData = $0 }
        default:
            break;
        }
    }
}
