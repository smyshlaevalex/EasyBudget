//
//  DayCell.swift
//  testCalendar
//
//  Created by Alexander Smyshlaev on 1/15/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DayCell: JTAppleDayCellView {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var eventView: UIView!
}
