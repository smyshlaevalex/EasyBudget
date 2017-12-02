//
//  ViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 11/30/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class RegularsTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var regulars = [Regular]()
    
    var chosenActionTitle: EditRegularTableViewController.ScheduledType? {
        didSet {
            performSegue(withIdentifier: "AddScheduledIncomeSegue", sender: self)
        }
    }
    
    var editRow: Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !BudgetModel.shared.isTutorialHasBeenShown {
            BudgetModel.shared.tutorialHasBeenShown()
            let tutorial = storyboard!.instantiateViewController(withIdentifier: "TutorialBlurViewController")
            
            present(tutorial, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        regulars = BudgetModel.shared.regulars
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addScheduledIncome(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: NSLocalizedString("TYPE", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let salaryAction = UIAlertAction(title: NSLocalizedString("INCOME", comment: ""), style: .default, handler: { _ in
            self.chosenActionTitle = .salary
        })
        let taxAction = UIAlertAction(title: NSLocalizedString("EXPENSE", comment: ""), style: .default, handler: { _ in
            self.chosenActionTitle = .tax
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel, handler: nil)
        
        actionSheet.addAction(salaryAction)
        actionSheet.addAction(taxAction)
        actionSheet.addAction(cancelAction)
        
        actionSheet.modalPresentationStyle = .popover
        actionSheet.popoverPresentationController?.barButtonItem = sender
        
        present(actionSheet, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regulars.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = regulars[indexPath.row].name
        
        let money = regulars[indexPath.row].money
        
        cell.detailTextLabel?.text = "\(abs(money).cleanString) р."
        
        if money > 0 {
            cell.detailTextLabel?.textColor = UIColor.flatGreenDark
        } else {
            cell.detailTextLabel?.textColor = UIColor.flatRedDark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: NSLocalizedString("DELETE", comment: ""), handler: { _,_  in
            let id = self.regulars[indexPath.row].id
            
            BudgetModel.shared.deleteRegular(withId: id!)
            
            self.regulars.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        })
        let editAction = UITableViewRowAction(style: .normal, title: NSLocalizedString("EDIT", comment: ""), handler: { _,_  in
            self.editRow = indexPath.row
            self.performSegue(withIdentifier: "EditScheduledIncomeSegue", sender: self)
        })
        editAction.backgroundColor = UIColor.blue
        
        
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: NSLocalizedString("NO_DATA", comment: ""))
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: NSLocalizedString("TAP_TO_ADD", comment: ""))
    }
    
    /*func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -50
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "ViewScheduledIncomeSegue":
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let regular = regulars[indexPath.row]
            
            let destination = segue.destination as! ViewRegularTableViewController
            
            destination.regular = regular
        case "AddScheduledIncomeSegue":
            let destination = segue.destination as! EditRegularTableViewController
            
            destination.regularEditorType = .add(chosenActionTitle!)
        case "EditScheduledIncomeSegue":
            let destination = segue.destination as! EditRegularTableViewController
            
            let regular = regulars[editRow!]
            
            destination.regularEditorType = .edit(regular)
        default:
            break;
        }
    }
}
