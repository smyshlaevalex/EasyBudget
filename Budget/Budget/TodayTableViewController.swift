//
//  TransactionsTableViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/14/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TodayTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var transactions = [Transaction]()
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        
        let transaction = transactions[indexPath.row]
        
        cell.nameLabel.text = transaction.name
        cell.money = transaction.money
        cell.date = transaction.date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: NSLocalizedString("DELETE", comment: ""), handler: { _,_  in
            let id = self.transactions[indexPath.row].id!
            
            BudgetModel.shared.deleteTransaction(withId: id)
            
            self.transactions = self.transactions.filter { $0.id != id }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        })
        
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: NSLocalizedString("NO_DATA", comment: ""))
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: NSLocalizedString("TAP_TO_ADD", comment: ""))
    }
    
    @IBAction func addTransaction(_ sender: UIBarButtonItem) {
        AddTransaction.presentAddTransactionViewsWithViewController(self, buttonSender: sender)
        //TransactionMakerCoordinator(presenterViewController: self).start()
    }
    
    func reload() {
        transactions = BudgetModel.shared.transactions.filter { Calendar.current.isDateInToday($0.date) }
        
        tableView.reloadData()
    }
}
