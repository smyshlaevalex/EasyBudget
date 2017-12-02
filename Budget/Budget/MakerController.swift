//
//  MakerController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 6/21/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class InputCell: UITableViewCell {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
}

class DatePickerCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!
}

class PickerCell: UITableViewCell {
    @IBOutlet weak var pickerView: UIPickerView!
}

class MakerController: UIViewController {
    @IBOutlet weak var helperLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewDataSourceAndDelegate: (UITableViewDataSource & UITableViewDelegate)? {
        didSet {
            tableView.dataSource = tableViewDataSourceAndDelegate
            tableView.delegate = tableViewDataSourceAndDelegate
        }
    }
}
