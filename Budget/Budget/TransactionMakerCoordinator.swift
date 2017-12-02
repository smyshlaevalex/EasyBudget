//
//  TransactionMakerCoordinator.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 6/21/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

// NameAmountRequest

protocol NameAmountRequestDelegate {
    func nameAmountReceived(name: String, amount: Double)
}

class NameAmountRequest: NSObject, UITableViewDataSource, UITableViewDelegate {
    var delegate: NameAmountRequestDelegate?
    
    var financeType: FinanceType!
    
    var helperText = "Type a name and amount for your income" // Unlocalized. yet.
    var navTitle = "Name and amount" // Unlocalized. yet.
    
    var rows = ["Name", "Amount"]
    var placeholders = ["example", "1000"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputCell
            
            cell.mainLabel.text = rows[indexPath.row]
            
            cell.textField.placeholder = placeholders[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
            cell.textLabel?.text = "Create"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row == 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 && indexPath.row == 0 else {
            return
        }
        
        guard let name = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InputCell)?.textField.text else {
            return
        }
        
        guard let amountStr = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? InputCell)?.textField.text else {
            return
        }
        
        guard let amount = Double(amountStr) else {
            return
        }
        
        delegate?.nameAmountReceived(name: name, amount: amount)
    }
}

// SelectFinance

protocol SelectFinanceDelegate {
    func financeIsSelected(finance: FinanceType)
}

class SelectFinance: NSObject, UITableViewDataSource, UITableViewDelegate {
    var delegate: SelectFinanceDelegate?
    var helperText = "What type of transaction you want to create?" // Unlocalized. yet.
    var navTitle = "Select type"
    
    var rows = ["Income", "Expense"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let finance = FinanceType(rawValue: indexPath.row) else {
            return
        }
        
        delegate?.financeIsSelected(finance: finance)
    }
}

class TransactionMakerCoordinator: Coordinator {
    var navigationController: UINavigationController {
        return navController
    }
    
    var presenter: UIViewController {
        return presenterController
    }
    
    var storyboard: UIStoryboard {
        return presenter.storyboard!
    }
    
    private var navController: UINavigationController
    private var presenterController: UIViewController
    
    var selectedFinance: FinanceType?
    
    init(presenterViewController: UIViewController) {
        presenterController = presenterViewController
        navController = UINavigationController()
        
        let selectFinance = SelectFinance()
        selectFinance.delegate = self
        
        let makerController = storyboard.instantiateViewController(withIdentifier: "makerController") as! MakerController
        let _ = makerController.view
        makerController.helperLabel.text = selectFinance.helperText
        makerController.tableViewDataSourceAndDelegate = selectFinance
        makerController.navigationItem.title = selectFinance.navTitle
        
        navigationController.viewControllers = [makerController]
    }
    
    func start() {
        presenter.present(navigationController, animated: true, completion: nil)
    }
}

extension TransactionMakerCoordinator: SelectFinanceDelegate {
    func financeIsSelected(finance: FinanceType) {
        selectedFinance = finance
        
        presentNameAmountController()
    }
}

extension TransactionMakerCoordinator: NameAmountRequestDelegate {
    func nameAmountReceived(name: String, amount: Double) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func presentNameAmountController() {
        guard let finance = selectedFinance else {
            return
        }
        
        let nameAmountRequest = NameAmountRequest()
        nameAmountRequest.delegate = self
        nameAmountRequest.financeType = finance
        
        let makerController = storyboard.instantiateViewController(withIdentifier: "makerController") as! MakerController
        let _ = makerController.view
        makerController.helperLabel.text = nameAmountRequest.helperText
        makerController.tableViewDataSourceAndDelegate = nameAmountRequest
        makerController.navigationItem.title = nameAmountRequest.navTitle
        
        navigationController.pushViewController(makerController, animated: true)
    }
}
