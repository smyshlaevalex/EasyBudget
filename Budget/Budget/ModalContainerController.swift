//
//  ModalContainerController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 1/7/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class ModalContainerController: UIViewController {
    var modalController: ModalController!
    
    var modalTitle: String!
    var inputs: [ModalTableViewController.CellInput]!
    var buttons: [ModalTableViewController.CellButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "embeddedModalViewControllerSegue":
            let destination = (segue.destination as! UINavigationController).topViewController! as! ModalTableViewController
            
            destination.modalTitle = modalTitle
            destination.inputs = inputs
            destination.buttons = buttons
        default:
            break
        }
    }
    
    deinit {
        modalController.dismiss(animated: true, completion: nil)
    }
}
