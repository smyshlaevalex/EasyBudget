//
//  TransactionCell.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/14/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var money: Double! {
        didSet {
            moneyLabel.text = "\(abs(money).cleanString) р."
            moneyLabel.textColor = money > 0 ? UIColor.flatGreenDark : UIColor.flatRedDark
        }
    }
    
    var date: Date! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            
            let time = dateFormatter.string(from: date)
            
            dateLabel.text = String(format: NSLocalizedString("AT_TIME", comment: ""), time)
        }
    }
}
