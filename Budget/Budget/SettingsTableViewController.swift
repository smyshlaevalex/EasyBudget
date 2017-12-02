//
//  SettingsTableViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/10/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var appVersion: String? {
        didSet {
            appVersionLabel.text = appVersion
        }
    }
    
    @IBOutlet weak var appVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            let tutorial = storyboard!.instantiateViewController(withIdentifier: "TutorialBlurViewController")
            
            present(tutorial, animated: true, completion: nil)
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            let alert = UIAlertController(title: NSLocalizedString("DELETE_ALL_DATA", comment: ""), message: NSLocalizedString("IMPOSSIBLE_TO_UNDO", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .destructive, handler: {_ in
                BudgetModel.shared.deleteAllContent()
            })
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            present(alert, animated: true, completion: nil)
        } /*else if indexPath.section == 2 && indexPath.row == 0 {
            exit(0)
        } else if indexPath.section == 2 && indexPath.row == 1 {
            UserDefaults.standard.set(false, forKey: "isTutorialHasBeenShown")
        }*/
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let highlightedIndexPaths = [IndexPath(row: 0, section: 1),
                                     IndexPath(row: 1, section: 1),
                                     /*IndexPath(row: 0, section: 2),
                                     IndexPath(row: 1, section: 2)*/]
        
        return highlightedIndexPaths.first(where: { $0 == indexPath }) != nil
    }
}
