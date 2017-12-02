//
//  AddTransaction.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 3/5/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

enum FinanceType: Int {
    case income
    case expense
}

class AddTransaction {
    static func presentAddTransactionViewsWithViewController(_ viewController: UIViewController, buttonSender: UIBarButtonItem? = nil) {
        func presentAddTransactionView(transactionType: FinanceType) {
            let modalController = viewController.storyboard!.instantiateViewController(withIdentifier: "modalController") as! ModalController
            
            modalController.modalTitle = NSLocalizedString("ADD", comment: "")
            modalController.inputs = [
                ModalTableViewController.CellInput(title: NSLocalizedString("TITLE", comment: ""), placeholder: NSLocalizedString("TITLE", comment: "")),
                ModalTableViewController.CellInput(title: NSLocalizedString("AMOUNT", comment: ""), placeholder: NSLocalizedString("AMOUNT", comment: ""), numerical: true, color: transactionType == .income ? UIColor.flatGreenDark : UIColor.flatRedDark)
            ]
            modalController.buttons = [
                ModalTableViewController.CellButton(type: .default, title: NSLocalizedString("ADD", comment: ""), handler: { modal in
                    if let name = modal.textFieldContent(of: 0), !name.isEmpty {
                        if let money = Double(modal.textFieldContent(of: 1)!) {
                            BudgetModel.shared.add(transaction: Transaction(name: name, money: transactionType == .income ? money : -money, date: Date()))
                            
                            modal.dismissModal()
                            
                            (viewController as? TodayTableViewController)?.reload()
                            return
                        }
                    }
                    
                    let alert = UIAlertController(title: NSLocalizedString("BLANK_FIELDS", comment: ""), message: NSLocalizedString("FILL_FIELDS", comment: ""), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    modal.present(alert: alert)
                }),
                ModalTableViewController.CellButton(type: .cancel, title: NSLocalizedString("CANCEL", comment: ""), handler: { modal in
                    modal.dismissModal()
                })
            ]
            
            viewController.present(modalController, animated: true, completion: nil)
        }
        
        let style: UIAlertControllerStyle?
        
        if UIDevice.current.userInterfaceIdiom == .pad && buttonSender == nil {
            style = .alert
        } else {
            style = .actionSheet
        }
        
        let actionSheet = UIAlertController(title: NSLocalizedString("Type", comment: ""), message: nil, preferredStyle: style!)
        
        let salaryAction = UIAlertAction(title: NSLocalizedString("INCOME", comment: ""), style: .default, handler: { _ in
            presentAddTransactionView(transactionType: .income)
        })
        let taxAction = UIAlertAction(title: NSLocalizedString("EXPENSE", comment: ""), style: .default, handler: { _ in
            presentAddTransactionView(transactionType: .expense)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel, handler: nil)
        
        actionSheet.addAction(salaryAction)
        actionSheet.addAction(taxAction)
        actionSheet.addAction(cancelAction)
        
        if let buttonSender = buttonSender {
            actionSheet.modalPresentationStyle = .popover
            actionSheet.popoverPresentationController?.barButtonItem = buttonSender
        }
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
