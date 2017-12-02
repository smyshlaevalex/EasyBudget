//
//  ViewIncomeTableViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/6/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class ViewRegularTableViewController: UITableViewController {
    var regular: Regular!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var startingDateLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = regular.name
        moneyLabel.text = "\(abs(regular.money).cleanString) р."
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        startingDateLabel.text = dateFormatter.string(from: regular.startingDate)
        
        
        scheduleLabel.text = Regular.russificated(schedule: regular.schedule, scheduleData: regular.scheduleData)
        
        if regular.money > 0 {
            moneyLabel.textColor = UIColor.flatGreenDark
        } else {
            moneyLabel.textColor = UIColor.flatRedDark
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "EditScheduledIncomeSegue":
            let destination = segue.destination as! EditRegularTableViewController
            
            destination.regularEditorType = .edit(regular)
        default:
            break;
        }
    }
}
