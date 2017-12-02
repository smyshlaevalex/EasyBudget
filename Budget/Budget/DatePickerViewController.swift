//
//  DatePickerViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/12/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var defaultDate: Date!
    var complition: ((Date) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setDate(defaultDate, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveDate(_ sender: UIBarButtonItem) {
        complition(datePicker.date)
        
        _ = navigationController?.popViewController(animated: true)
    }
}
