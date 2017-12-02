//
//  TodayViewController.swift
//  Budget-Widget
//
//  Created by Alexander Smyshlaev on 3/5/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var visualEffectForButton: UIVisualEffectView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10, *) {
            visualEffectForButton.effect = UIBlurEffect(style: .dark)
        } else {
            visualEffectForButton.effect = UIBlurEffect(style: .light)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.noData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    @IBAction func addTransaction(_ sender: UIButton) {
        extensionContext?.open(URL(string: "easybudget://?openAction=openTransactionCreator")!) { print($0) }
    }
}
